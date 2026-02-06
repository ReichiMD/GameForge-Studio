/**
 * Vanilla Minecraft Item Data
 *
 * Dieser Helper lädt die Item-Statistiken aus library/vanilla_stats.json
 * und stellt Funktionen bereit, um Items nach ID oder Kategorie zu finden.
 */

import vanillaStatsJson from '../../../library/vanilla_stats.json';

// TypeScript Types für bessere Auto-Completion
export interface ItemStats {
  damage?: number;
  attack_speed?: number;
  durability?: number;
  enchantable?: boolean;
  stackable?: boolean;
  armor?: number;
  armor_toughness?: number;
  knockback_resistance?: number;
  nutrition?: number;
  saturation?: number;
}

export interface VanillaItem {
  id: string;
  name: string;
  name_en: string;
  category: 'weapons' | 'armor' | 'food' | 'tools' | 'blocks' | 'mobs';
  type?: string;
  emoji: string;
  rarity: 'common' | 'uncommon' | 'rare' | 'epic';
  stats: ItemStats;
  texture: string;
}

// Alle Items aus der JSON-Datei
const vanillaItems: Record<string, VanillaItem> = vanillaStatsJson.items as any;

/**
 * Holt ein Item nach seiner ID (z.B. "diamond_sword")
 * @param id - Die Item-ID (ohne "minecraft:" Prefix)
 * @returns Das Item oder undefined wenn nicht gefunden
 */
export const getItemById = (id: string): VanillaItem | undefined => {
  return vanillaItems[id];
};

/**
 * Holt alle Items einer bestimmten Kategorie
 * @param category - Die Kategorie (weapons, armor, food, etc.)
 * @returns Array von Items
 */
export const getItemsByCategory = (category: string): VanillaItem[] => {
  return Object.values(vanillaItems)
    .filter(item => item && item.category === category);
};

/**
 * Holt alle verfügbaren Item-IDs
 * @returns Array von Item-IDs
 */
export const getAllItemIds = (): string[] => {
  return Object.keys(vanillaItems).filter(key => !key.startsWith('_comment'));
};

/**
 * Prüft ob ein Item existiert
 * @param id - Die Item-ID
 * @returns true wenn das Item existiert
 */
export const itemExists = (id: string): boolean => {
  return !!vanillaItems[id];
};

/**
 * Generiert die vollständige GitHub-URL für die Item-Texture
 * @param item - Das Item
 * @returns Die URL zur Texture auf GitHub
 */
export const getItemTextureUrl = (item: VanillaItem): string => {
  const baseUrl = 'https://raw.githubusercontent.com/ReichiMD/fabrik-library/main';
  return `${baseUrl}/${item.texture}`;
};

/**
 * Holt Standard-Werte für Slider basierend auf Item-Kategorie
 * @param item - Das Item
 * @returns Min, Max und Standard-Werte für alle relevanten Stats
 */
export const getStatRanges = (item: VanillaItem) => {
  const ranges: Record<string, { min: number; max: number; default: number }> = {};

  if (item.category === 'weapons') {
    if (item.stats.damage !== undefined) {
      ranges.damage = {
        min: 0,
        max: item.stats.damage * 3,
        default: item.stats.damage
      };
    }
    if (item.stats.attack_speed !== undefined) {
      ranges.attack_speed = {
        min: 0.1,
        max: 4.0,
        default: item.stats.attack_speed
      };
    }
    if (item.stats.durability !== undefined) {
      ranges.durability = {
        min: 1,
        max: item.stats.durability * 2,
        default: item.stats.durability
      };
    }
  }

  if (item.category === 'armor') {
    if (item.stats.armor !== undefined) {
      ranges.armor = {
        min: 0,
        max: item.stats.armor * 2,
        default: item.stats.armor
      };
    }
    if (item.stats.armor_toughness !== undefined) {
      ranges.armor_toughness = {
        min: 0,
        max: item.stats.armor_toughness * 2,
        default: item.stats.armor_toughness
      };
    }
    if (item.stats.durability !== undefined) {
      ranges.durability = {
        min: 1,
        max: item.stats.durability * 2,
        default: item.stats.durability
      };
    }
  }

  if (item.category === 'food') {
    if (item.stats.nutrition !== undefined) {
      ranges.nutrition = {
        min: 0,
        max: 20,
        default: item.stats.nutrition
      };
    }
    if (item.stats.saturation !== undefined) {
      ranges.saturation = {
        min: 0,
        max: 20,
        default: item.stats.saturation
      };
    }
  }

  return ranges;
};

// Exportiere auch die rohen Daten für direkten Zugriff wenn nötig
export const rawVanillaData = vanillaStatsJson;
