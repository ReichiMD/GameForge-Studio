import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  TextInput,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { colors, spacing, sizing, typography } from '../theme';
import type { AuthData } from '../../App';

interface LoginScreenProps {
  onLogin: (data: AuthData) => void;
}

export default function LoginScreen({ onLogin }: LoginScreenProps) {
  const [username, setUsername] = useState('');
  const [githubToken, setGithubToken] = useState('');
  const [showToken, setShowToken] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = () => {
    if (!username.trim()) {
      setError('Bitte gib deinen Namen ein');
      return;
    }
    if (!githubToken.trim()) {
      setError('Bitte gib dein GitHub Token ein');
      return;
    }
    setError('');
    onLogin({ username: username.trim(), githubToken: githubToken.trim() });
  };

  return (
    <SafeAreaView style={styles.container}>
      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={styles.keyboardView}
      >
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          showsVerticalScrollIndicator={false}
          keyboardShouldPersistTaps="handled"
        >
          {/* Logo / Branding */}
          <View style={styles.brandSection}>
            <Text style={styles.logoEmoji}>⚒️</Text>
            <Text style={styles.appName}>GameForge</Text>
            <Text style={styles.appSubtitle}>Studio</Text>
            <Text style={styles.tagline}>Deine Minecraft Werkstatt</Text>
          </View>

          {/* Login Form */}
          <View style={styles.formSection}>
            {/* Username */}
            <View style={styles.inputGroup}>
              <Text style={styles.inputLabel}>👤 Benutzername</Text>
              <TextInput
                style={styles.input}
                value={username}
                onChangeText={(text) => {
                  setUsername(text);
                  setError('');
                }}
                placeholder="z.B. ReichiMD"
                placeholderTextColor={colors.textMuted}
                autoCapitalize="none"
                autoCorrect={false}
              />
            </View>

            {/* GitHub Token */}
            <View style={styles.inputGroup}>
              <View style={styles.tokenLabelRow}>
                <Text style={styles.inputLabel}>🔑 GitHub Token</Text>
                <TouchableOpacity onPress={() => setShowToken(!showToken)}>
                  <Text style={styles.toggleText}>
                    {showToken ? '🙈 Verbergen' : '👁️ Zeigen'}
                  </Text>
                </TouchableOpacity>
              </View>
              <TextInput
                style={styles.input}
                value={githubToken}
                onChangeText={(text) => {
                  setGithubToken(text);
                  setError('');
                }}
                placeholder="ghp_xxxxxxxxxxxx"
                placeholderTextColor={colors.textMuted}
                secureTextEntry={!showToken}
                autoCapitalize="none"
                autoCorrect={false}
              />
              <Text style={styles.tokenHint}>
                Damit bekommst du Zugriff auf deine Repositories
              </Text>
            </View>

            {/* Error Message */}
            {error ? (
              <View style={styles.errorContainer}>
                <Text style={styles.errorText}>⚠️ {error}</Text>
              </View>
            ) : null}

            {/* Login Button */}
            <TouchableOpacity
              style={[
                styles.loginBtn,
                (!username.trim() || !githubToken.trim()) && styles.loginBtnDisabled,
              ]}
              onPress={handleLogin}
              activeOpacity={0.8}
            >
              <Text style={styles.loginBtnEmoji}>🚀</Text>
              <Text style={styles.loginBtnText}>Anmelden</Text>
            </TouchableOpacity>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  keyboardView: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
    justifyContent: 'center',
    padding: spacing.xl,
  },
  brandSection: {
    alignItems: 'center',
    marginBottom: spacing.xxxl,
  },
  logoEmoji: {
    fontSize: 72,
    marginBottom: spacing.md,
  },
  appName: {
    fontSize: typography.xxxl,
    fontWeight: typography.bold,
    color: colors.text,
  },
  appSubtitle: {
    fontSize: typography.xl,
    fontWeight: typography.semibold,
    color: colors.primary,
    marginBottom: spacing.sm,
  },
  tagline: {
    fontSize: typography.md,
    color: colors.textSecondary,
  },
  formSection: {
    gap: spacing.lg,
  },
  inputGroup: {
    gap: spacing.sm,
  },
  inputLabel: {
    fontSize: typography.md,
    fontWeight: typography.semibold,
    color: colors.text,
  },
  tokenLabelRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  toggleText: {
    fontSize: typography.sm,
    color: colors.primary,
  },
  input: {
    backgroundColor: colors.surface,
    borderRadius: sizing.radiusMedium,
    padding: spacing.lg,
    fontSize: typography.md,
    color: colors.text,
    borderWidth: 1,
    borderColor: colors.border,
  },
  tokenHint: {
    fontSize: typography.xs,
    color: colors.textMuted,
    marginTop: spacing.xs,
  },
  errorContainer: {
    backgroundColor: 'rgba(239, 68, 68, 0.1)',
    borderRadius: sizing.radiusMedium,
    padding: spacing.md,
    borderWidth: 1,
    borderColor: colors.error,
  },
  errorText: {
    fontSize: typography.sm,
    color: colors.error,
  },
  loginBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: spacing.md,
    backgroundColor: colors.primary,
    paddingVertical: spacing.xl,
    borderRadius: sizing.radiusLarge,
    marginTop: spacing.md,
    minHeight: 64,
    shadowColor: colors.primary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 15,
    elevation: 8,
  },
  loginBtnDisabled: {
    opacity: 0.5,
  },
  loginBtnEmoji: {
    fontSize: 24,
  },
  loginBtnText: {
    fontSize: typography.lg,
    fontWeight: typography.bold,
    color: colors.text,
  },
});
