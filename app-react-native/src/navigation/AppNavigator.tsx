import React from 'react';
import { Text, View, StyleSheet } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import {
  HomeScreen,
  LibraryScreen,
  WorkshopScreen,
  SettingsScreen,
  CreateProjectScreen,
  ProjectDetailScreen,
} from '../screens';
import { colors, spacing, sizing, typography } from '../theme';
import type { AuthData } from '../../App';

const Tab = createBottomTabNavigator();
const HomeStack = createNativeStackNavigator();

interface AppNavigatorProps {
  auth: AuthData;
  onLogout: () => void;
}

interface TabIconProps {
  emoji: string;
  focused: boolean;
}

const TabIcon = ({ emoji, focused }: TabIconProps) => (
  <View style={[styles.tabIconContainer, focused && styles.tabIconContainerActive]}>
    <Text style={styles.tabIconEmoji}>{emoji}</Text>
  </View>
);

const HomeStackNavigator = () => (
  <HomeStack.Navigator
    screenOptions={{
      headerShown: false,
    }}
  >
    <HomeStack.Screen name="HomeMain" component={HomeScreen} />
    <HomeStack.Screen name="CreateProject" component={CreateProjectScreen} />
    <HomeStack.Screen name="ProjectDetail" component={ProjectDetailScreen} />
  </HomeStack.Navigator>
);

export default function AppNavigator({ auth, onLogout }: AppNavigatorProps) {
  return (
    <NavigationContainer>
      <Tab.Navigator
        screenOptions={{
          headerShown: false,
          tabBarStyle: styles.tabBar,
          tabBarActiveTintColor: colors.primary,
          tabBarInactiveTintColor: colors.textSecondary,
          tabBarLabelStyle: styles.tabBarLabel,
        }}
      >
        <Tab.Screen
          name="Home"
          component={HomeStackNavigator}
          options={{
            tabBarLabel: 'Home',
            tabBarIcon: ({ focused }) => <TabIcon emoji="🏠" focused={focused} />,
          }}
        />
        <Tab.Screen
          name="Library"
          component={LibraryScreen}
          options={{
            tabBarLabel: 'Bibliothek',
            tabBarIcon: ({ focused }) => <TabIcon emoji="📚" focused={focused} />,
          }}
        />
        <Tab.Screen
          name="Workshop"
          component={WorkshopScreen}
          options={{
            tabBarLabel: 'Workshop',
            tabBarIcon: ({ focused }) => <TabIcon emoji="🔧" focused={focused} />,
          }}
        />
        <Tab.Screen
          name="Settings"
          component={SettingsScreen}
          options={{
            tabBarLabel: 'Settings',
            tabBarIcon: ({ focused }) => <TabIcon emoji="⚙️" focused={focused} />,
          }}
        />
      </Tab.Navigator>
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  tabBar: {
    backgroundColor: colors.surface,
    borderTopWidth: 1,
    borderTopColor: colors.border,
    height: sizing.bottomNavHeight,
    paddingTop: spacing.sm,
    paddingBottom: spacing.lg,
  },
  tabBarLabel: {
    fontSize: typography.xs,
    fontWeight: typography.medium,
    marginTop: spacing.xs,
  },
  tabIconContainer: {
    padding: spacing.sm,
    borderRadius: sizing.radiusMedium,
  },
  tabIconContainerActive: {
    backgroundColor: colors.primaryAlpha,
  },
  tabIconEmoji: {
    fontSize: 24,
  },
});
