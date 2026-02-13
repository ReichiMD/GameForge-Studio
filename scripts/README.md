# Scripts

This directory contains utility scripts for the GameForge Studio project.

## 📚 update_bedrock_docs.sh

Downloads and formats the latest Minecraft Bedrock Wiki documentation for AI assistant usage.

### Usage

**Manual execution:**
```bash
# Auto-detect version
./scripts/update_bedrock_docs.sh

# Specify version manually
./scripts/update_bedrock_docs.sh 1.21.132
```

**Via GitHub Actions:**
1. Go to: **Actions** → **Update Bedrock Documentation**
2. Click: **Run workflow**
3. Enter version (optional, leave empty for auto-detect)
4. Click: **Run workflow**

### What it does

1. **Clones** Bedrock Wiki from GitHub
2. **Filters** out web-specific files (`_sidebar.md`, `_navbar.md`, etc.)
3. **Creates** two optimized files:
   - `master_index_X.X.X.txt` - Index of all documentation files
   - `docs_complete_X.X.X.txt` - Complete documentation with file markers
4. **Saves** version info to `version.txt`

### Output Files

```
docs/bedrock-wiki/
├── master_index_1.21.132.txt    # Index with all file paths
├── docs_complete_1.21.132.txt   # Complete documentation
└── version.txt                   # Current version (1.21.132)
```

### Why this format?

**Token Efficiency:**
- WebFetch: ~3000-5000 tokens per search 🐌
- This format: ~300-500 tokens per search ⚡
- **Savings: ~85-90%!** 🎉

**How AI uses it:**
1. Search index for topic → find file path
2. Grep docs_complete for file path → get full content
3. One command = instant results!

**Example:**
```bash
# Find item components documentation
grep "item-components" docs/bedrock-wiki/master_index_1.21.132.txt

# Get the full content
grep -A 100 "items/item-components.md" docs/bedrock-wiki/docs_complete_1.21.132.txt
```

### Filtered Files

The script automatically filters out:
- `_sidebar.md`, `_navbar.md` - Web navigation
- `index.md` - Web homepage
- `README.md`, `CONTRIBUTING.md` - GitHub meta files
- Files in `/meta/` or `/contribute/` directories
- Non-documentation files

### Requirements

- `bash` 4.0+
- `git`
- Internet connection (to clone wiki)

### Notes

- Script is **safe** - only reads from wiki, writes to `docs/bedrock-wiki/`
- Automatically cleans up temporary files
- Can be run multiple times (idempotent)
- GitHub Actions workflow commits changes automatically
