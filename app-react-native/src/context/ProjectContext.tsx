import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

const PROJECTS_STORAGE_KEY = '@gameforge_projects';

export interface ProjectItem {
  id: string;
  name: string;
  emoji: string;
  stat: string;
  rarity: string;
  category: string;
}

export interface Project {
  id: string;
  name: string;
  category: string;
  emoji: string;
  items: ProjectItem[];
  createdAt: string;
}

interface ProjectContextType {
  projects: Project[];
  addProject: (name: string, category: string, emoji: string) => Project;
  addItemToProject: (projectId: string, item: Omit<ProjectItem, 'id'>) => void;
  getProject: (projectId: string) => Project | undefined;
  deleteProject: (projectId: string) => void;
  removeItemFromProject: (projectId: string, itemId: string) => void;
}

const ProjectContext = createContext<ProjectContextType | undefined>(undefined);

export function ProjectProvider({ children }: { children: React.ReactNode }) {
  const [projects, setProjects] = useState<Project[]>([]);

  useEffect(() => {
    loadProjects();
  }, []);

  const saveProjects = async (updated: Project[]) => {
    try {
      await AsyncStorage.setItem(PROJECTS_STORAGE_KEY, JSON.stringify(updated));
    } catch (e) {
      // Ignore save errors
    }
  };

  const loadProjects = async () => {
    try {
      const stored = await AsyncStorage.getItem(PROJECTS_STORAGE_KEY);
      if (stored) {
        setProjects(JSON.parse(stored));
      }
    } catch (e) {
      // Ignore load errors
    }
  };

  const addProject = useCallback((name: string, category: string, emoji: string): Project => {
    const newProject: Project = {
      id: Date.now().toString(),
      name,
      category,
      emoji,
      items: [],
      createdAt: new Date().toISOString(),
    };
    setProjects(prev => {
      const updated = [...prev, newProject];
      saveProjects(updated);
      return updated;
    });
    return newProject;
  }, []);

  const addItemToProject = useCallback((projectId: string, item: Omit<ProjectItem, 'id'>) => {
    setProjects(prev => {
      const updated = prev.map(p => {
        if (p.id === projectId) {
          return {
            ...p,
            items: [...p.items, { ...item, id: Date.now().toString() }],
          };
        }
        return p;
      });
      saveProjects(updated);
      return updated;
    });
  }, []);

  const getProject = useCallback((projectId: string) => {
    return projects.find(p => p.id === projectId);
  }, [projects]);

  const deleteProject = useCallback((projectId: string) => {
    setProjects(prev => {
      const updated = prev.filter(p => p.id !== projectId);
      saveProjects(updated);
      return updated;
    });
  }, []);

  const removeItemFromProject = useCallback((projectId: string, itemId: string) => {
    setProjects(prev => {
      const updated = prev.map(p => {
        if (p.id === projectId) {
          return {
            ...p,
            items: p.items.filter(item => item.id !== itemId),
          };
        }
        return p;
      });
      saveProjects(updated);
      return updated;
    });
  }, []);

  return (
    <ProjectContext.Provider value={{ projects, addProject, addItemToProject, getProject, deleteProject, removeItemFromProject }}>
      {children}
    </ProjectContext.Provider>
  );
}

export function useProjects() {
  const context = useContext(ProjectContext);
  if (!context) {
    throw new Error('useProjects must be used within a ProjectProvider');
  }
  return context;
}
