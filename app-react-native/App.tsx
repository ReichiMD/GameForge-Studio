import React, { useState, useEffect } from 'react';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import AsyncStorage from '@react-native-async-storage/async-storage';
import AppNavigator from './src/navigation/AppNavigator';
import LoginScreen from './src/screens/LoginScreen';
import { ProjectProvider } from './src/context/ProjectContext';

const AUTH_STORAGE_KEY = '@gameforge_auth';

export interface AuthData {
  username: string;
  githubToken: string;
}

export default function App() {
  const [auth, setAuth] = useState<AuthData | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    loadAuth();
  }, []);

  const loadAuth = async () => {
    try {
      const stored = await AsyncStorage.getItem(AUTH_STORAGE_KEY);
      if (stored) {
        setAuth(JSON.parse(stored));
      }
    } catch (e) {
      // Ignore load errors
    } finally {
      setIsLoading(false);
    }
  };

  const handleLogin = async (data: AuthData) => {
    await AsyncStorage.setItem(AUTH_STORAGE_KEY, JSON.stringify(data));
    setAuth(data);
  };

  const handleLogout = async () => {
    await AsyncStorage.removeItem(AUTH_STORAGE_KEY);
    setAuth(null);
  };

  if (isLoading) {
    return (
      <SafeAreaProvider>
        <StatusBar style="light" />
      </SafeAreaProvider>
    );
  }

  return (
    <SafeAreaProvider>
      <StatusBar style="light" />
      <ProjectProvider>
        {auth ? (
          <AppNavigator auth={auth} onLogout={handleLogout} />
        ) : (
          <LoginScreen onLogin={handleLogin} />
        )}
      </ProjectProvider>
    </SafeAreaProvider>
  );
}
