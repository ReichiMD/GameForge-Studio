#!/bin/bash

################################################################################
# Bedrock Wiki Documentation Updater
#
# This script downloads the latest Minecraft Bedrock Wiki documentation from
# GitHub and creates two optimized files for AI assistant usage:
# 1. master_index_X.X.X.txt - Index of all documentation files
# 2. docs_complete_X.X.X.txt - Complete documentation with file markers
#
# Usage:
#   ./scripts/update_bedrock_docs.sh [VERSION]
#
# Examples:
#   ./scripts/update_bedrock_docs.sh 1.21.132
#   ./scripts/update_bedrock_docs.sh          # Auto-detect version
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/Bedrock-OSS/bedrock-wiki.git"
TEMP_DIR="/tmp/bedrock-wiki-temp"
OUTPUT_DIR="docs/bedrock-wiki"
DOCS_SOURCE_DIR="docs"

# Version parameter (optional)
VERSION="$1"

################################################################################
# Functions
################################################################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Cleanup function
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        log_info "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}

# Detect Bedrock version from wiki
detect_version() {
    log_info "Attempting to detect Bedrock version from wiki..."

    # Try to find version in common locations
    local version_file="$TEMP_DIR/$DOCS_SOURCE_DIR/meta/version.md"
    local changelog_file="$TEMP_DIR/$DOCS_SOURCE_DIR/meta/changelog.md"

    # Method 1: Check version.md if it exists
    if [ -f "$version_file" ]; then
        version=$(grep -oP "(?<=1\.)\d+\.\d+" "$version_file" | head -1)
        if [ -n "$version" ]; then
            echo "1.$version"
            return 0
        fi
    fi

    # Method 2: Check changelog.md
    if [ -f "$changelog_file" ]; then
        version=$(grep -oP "1\.\d+\.\d+" "$changelog_file" | head -1)
        if [ -n "$version" ]; then
            echo "$version"
            return 0
        fi
    fi

    # Method 3: Search all .md files for version mentions
    version=$(find "$TEMP_DIR/$DOCS_SOURCE_DIR" -name "*.md" -type f -exec grep -oP "1\.\d+\.\d+" {} \; | sort -V | tail -1)
    if [ -n "$version" ]; then
        echo "$version"
        return 0
    fi

    # Fallback: Use current date
    log_warning "Could not auto-detect version. Using date-based version."
    echo "1.21.$(date +%Y%m%d)"
}

# Filter out web-specific files
should_skip_file() {
    local file="$1"
    local basename=$(basename "$file")

    # Skip these files
    case "$basename" in
        _sidebar.md|_navbar.md|index.md|README.md|CONTRIBUTING.md)
            return 0
            ;;
    esac

    # Skip files in these directories
    if [[ "$file" == *"/meta/"* ]] || \
       [[ "$file" == *"/contribute/"* ]] || \
       [[ "$file" == *"/.github/"* ]]; then
        return 0
    fi

    return 1
}

################################################################################
# Main Script
################################################################################

# Set trap for cleanup
trap cleanup EXIT

log_info "Starting Bedrock Wiki Documentation Update"
echo ""

# Step 1: Clean and prepare
log_info "Step 1/6: Preparing directories..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
mkdir -p "$OUTPUT_DIR"

# Step 2: Clone repository
log_info "Step 2/6: Cloning Bedrock Wiki repository..."
log_info "Repository: $REPO_URL"
git clone --depth 1 --branch wiki "$REPO_URL" "$TEMP_DIR" 2>&1 | sed 's/^/  /'
log_success "Repository cloned successfully"
echo ""

# Step 3: Detect or use provided version
log_info "Step 3/6: Determining Bedrock version..."
if [ -z "$VERSION" ]; then
    VERSION=$(detect_version)
    log_success "Auto-detected version: $VERSION"
else
    log_success "Using provided version: $VERSION"
fi
echo ""

# Step 4: Create file list and index
log_info "Step 4/6: Building documentation index..."

INDEX_FILE="$OUTPUT_DIR/master_index_${VERSION}.txt"
DOCS_FILE="$OUTPUT_DIR/docs_complete_${VERSION}.txt"
VERSION_FILE="$OUTPUT_DIR/version.txt"

# Clear output files
> "$INDEX_FILE"
> "$DOCS_FILE"

# Write header to index
cat > "$INDEX_FILE" << EOF
################################################################################
# Minecraft Bedrock Wiki - Documentation Index
# Version: $VERSION
# Generated: $(date +"%Y-%m-%d %H:%M:%S")
# Source: https://github.com/Bedrock-OSS/bedrock-wiki
#
# This file contains an index of all documentation files.
# Each line shows the relative path to a documentation file.
# Use this index to quickly find the file you need, then search for it
# in docs_complete_${VERSION}.txt using the file path as marker.
#
# Example:
#   grep -A 100 "items/item-components.md" docs_complete_${VERSION}.txt
################################################################################

EOF

# Write header to docs
cat > "$DOCS_FILE" << EOF
################################################################################
# Minecraft Bedrock Wiki - Complete Documentation
# Version: $VERSION
# Generated: $(date +"%Y-%m-%d %H:%M:%S")
# Source: https://github.com/Bedrock-OSS/bedrock-wiki
#
# This file contains the complete Bedrock Wiki documentation.
# Each documentation file is marked with:
#   ===== path/to/file.md =====
#
# To find a specific topic:
# 1. Check master_index_${VERSION}.txt for the file path
# 2. Search this file: grep -A 100 "path/to/file.md" docs_complete_${VERSION}.txt
#
# Token-efficient: One grep command = ~300-500 tokens!
################################################################################

EOF

file_count=0

# Find all .md files in docs/ directory
while IFS= read -r -d '' file; do
    # Get relative path from docs/ directory
    rel_path="${file#$TEMP_DIR/$DOCS_SOURCE_DIR/}"

    # Skip if this file should be filtered out
    if should_skip_file "$file"; then
        continue
    fi

    # Add to index
    echo "$rel_path" >> "$INDEX_FILE"

    # Add to complete docs with marker
    echo "" >> "$DOCS_FILE"
    echo "===== $rel_path =====" >> "$DOCS_FILE"
    echo "" >> "$DOCS_FILE"
    cat "$file" >> "$DOCS_FILE"
    echo "" >> "$DOCS_FILE"

    ((file_count++))

done < <(find "$TEMP_DIR/$DOCS_SOURCE_DIR" -name "*.md" -type f -print0 | sort -z)

log_success "Processed $file_count documentation files"
echo ""

# Step 5: Save version info
log_info "Step 5/6: Saving version information..."
echo "$VERSION" > "$VERSION_FILE"
log_success "Version saved to $VERSION_FILE"
echo ""

# Step 6: Display summary
log_info "Step 6/6: Generating summary..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_success "Documentation update completed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  📋 Version:         $VERSION"
echo "  📁 Output Directory: $OUTPUT_DIR"
echo "  📄 Files Processed:  $file_count"
echo ""
echo "  Generated Files:"
echo "    • master_index_${VERSION}.txt    ($(wc -l < "$INDEX_FILE") lines)"
echo "    • docs_complete_${VERSION}.txt   ($(wc -l < "$DOCS_FILE") lines)"
echo "    • version.txt                     (current version)"
echo ""
echo "  File Sizes:"
echo "    • Index:    $(du -h "$INDEX_FILE" | cut -f1)"
echo "    • Docs:     $(du -h "$DOCS_FILE" | cut -f1)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
log_info "Usage example:"
echo "  grep -A 100 \"items/item-components.md\" $DOCS_FILE"
echo ""
log_success "Done! 🎉"
