import { colors } from '../theme';

export type Rarity = 'common' | 'rare' | 'epic' | 'legendary';

export interface LibraryItem {
  id: string;
  name: string;
  emoji: string;
  category: string;
  rarity: Rarity;
  stat: string;
}

export const demoItems: LibraryItem[] = [
  // Weapons
  { id: 'w1', name: 'Drachenschwert', emoji: '⚔️', category: 'weapons', rarity: 'legendary', stat: '50 DMG' },
  { id: 'w2', name: 'Eis Klinge', emoji: '🗡️', category: 'weapons', rarity: 'rare', stat: '25 DMG' },
  { id: 'w3', name: 'Diamant Schwert', emoji: '⚔️', category: 'weapons', rarity: 'epic', stat: '35 DMG' },
  { id: 'w4', name: 'Stein Schwert', emoji: '🗡️', category: 'weapons', rarity: 'common', stat: '10 DMG' },
  { id: 'w5', name: 'Bogen', emoji: '🏹', category: 'weapons', rarity: 'rare', stat: '20 DMG' },
  { id: 'w6', name: 'Diamant Axt', emoji: '🪓', category: 'weapons', rarity: 'epic', stat: '30 DMG' },
  // Armor
  { id: 'a1', name: 'Diamant Schild', emoji: '🛡️', category: 'armor', rarity: 'epic', stat: '+20 DEF' },
  { id: 'a2', name: 'König Helm', emoji: '👑', category: 'armor', rarity: 'legendary', stat: '+15 DEF' },
  { id: 'a3', name: 'Eisen Brustpanzer', emoji: '🦺', category: 'armor', rarity: 'rare', stat: '+12 DEF' },
  { id: 'a4', name: 'Leder Hose', emoji: '👖', category: 'armor', rarity: 'common', stat: '+5 DEF' },
  // Mobs
  { id: 'm1', name: 'Zombie', emoji: '🧟', category: 'mobs', rarity: 'common', stat: '20 HP' },
  { id: 'm2', name: 'Creeper', emoji: '💚', category: 'mobs', rarity: 'rare', stat: '30 HP' },
  { id: 'm3', name: 'Enderman', emoji: '🖤', category: 'mobs', rarity: 'epic', stat: '40 HP' },
  { id: 'm4', name: 'Drache', emoji: '🐉', category: 'mobs', rarity: 'legendary', stat: '200 HP' },
  // Food
  { id: 'f1', name: 'Goldener Apfel', emoji: '🍎', category: 'food', rarity: 'rare', stat: '+5 HP' },
  { id: 'f2', name: 'Steak', emoji: '🥩', category: 'food', rarity: 'common', stat: '+8 HP' },
  { id: 'f3', name: 'Heiltrank', emoji: '🧪', category: 'food', rarity: 'rare', stat: '+10 HP' },
  { id: 'f4', name: 'Zaubertrank', emoji: '⚗️', category: 'food', rarity: 'epic', stat: '+20 HP' },
  // Blocks
  { id: 'b1', name: 'Glowstone', emoji: '✨', category: 'blocks', rarity: 'rare', stat: 'Licht' },
  { id: 'b2', name: 'Obsidian', emoji: '🟪', category: 'blocks', rarity: 'epic', stat: 'Sehr Hart' },
  { id: 'b3', name: 'TNT', emoji: '🧨', category: 'blocks', rarity: 'rare', stat: 'Explosion' },
  { id: 'b4', name: 'Diamant Block', emoji: '💎', category: 'blocks', rarity: 'legendary', stat: 'Deko' },
  // Tools
  { id: 't1', name: 'Diamant Spitzhacke', emoji: '⛏️', category: 'tools', rarity: 'epic', stat: '8 SPD' },
  { id: 't2', name: 'Gold Schaufel', emoji: '🥄', category: 'tools', rarity: 'rare', stat: '10 SPD' },
  { id: 't3', name: 'Netherite Hacke', emoji: '🪓', category: 'tools', rarity: 'legendary', stat: '12 SPD' },
];

export const rarityColors: Record<Rarity, string> = {
  common: colors.rarity.common,
  rare: colors.rarity.rare,
  epic: colors.rarity.epic,
  legendary: colors.rarity.legendary,
};

export const rarityLabels: Record<Rarity, string> = {
  common: 'Normal',
  rare: 'Selten',
  epic: 'Episch',
  legendary: 'Legendär',
};

export const categoryEmojis: Record<string, string> = {
  weapons: '⚔️',
  armor: '🛡️',
  mobs: '👾',
  food: '🍖',
  blocks: '🧱',
  tools: '🔨',
};
