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
  // Weapons (echte IDs aus vanilla_stats.json)
  { id: 'diamond_sword', name: 'Diamantschwert', emoji: '⚔️', category: 'weapons', rarity: 'rare', stat: '7 ❤️' },
  { id: 'iron_sword', name: 'Eisenschwert', emoji: '⚔️', category: 'weapons', rarity: 'common', stat: '6 ❤️' },
  { id: 'stone_sword', name: 'Steinschwert', emoji: '⚔️', category: 'weapons', rarity: 'common', stat: '5 ❤️' },
  { id: 'wooden_sword', name: 'Holzschwert', emoji: '🗡️', category: 'weapons', rarity: 'common', stat: '4 ❤️' },
  { id: 'netherite_sword', name: 'Netheritschwert', emoji: '⚔️', category: 'weapons', rarity: 'epic', stat: '8 ❤️' },
  { id: 'golden_sword', name: 'Goldschwert', emoji: '⚔️', category: 'weapons', rarity: 'rare', stat: '4 ❤️' },
  { id: 'bow', name: 'Bogen', emoji: '🏹', category: 'weapons', rarity: 'common', stat: '9 ❤️' },
  { id: 'crossbow', name: 'Armbrust', emoji: '🏹', category: 'weapons', rarity: 'rare', stat: '9 ❤️' },
  { id: 'trident', name: 'Dreizack', emoji: '🔱', category: 'weapons', rarity: 'epic', stat: '9 ❤️' },
  // Armor (echte IDs aus vanilla_stats.json)
  { id: 'diamond_helmet', name: 'Diamanthelm', emoji: '🪖', category: 'armor', rarity: 'rare', stat: '3 🛡️' },
  { id: 'diamond_chestplate', name: 'Diamantharnisch', emoji: '🦺', category: 'armor', rarity: 'rare', stat: '8 🛡️' },
  { id: 'diamond_leggings', name: 'Diamanthose', emoji: '👖', category: 'armor', rarity: 'rare', stat: '6 🛡️' },
  { id: 'diamond_boots', name: 'Diamantstiefel', emoji: '🥾', category: 'armor', rarity: 'rare', stat: '3 🛡️' },
  { id: 'iron_helmet', name: 'Eisenhelm', emoji: '🪖', category: 'armor', rarity: 'common', stat: '2 🛡️' },
  { id: 'iron_chestplate', name: 'Eisenharnisch', emoji: '🦺', category: 'armor', rarity: 'common', stat: '6 🛡️' },
  { id: 'leather_helmet', name: 'Lederkappe', emoji: '🧢', category: 'armor', rarity: 'common', stat: '1 🛡️' },
  // Mobs
  { id: 'm1', name: 'Zombie', emoji: '🧟', category: 'mobs', rarity: 'common', stat: '20 HP' },
  { id: 'm2', name: 'Creeper', emoji: '💚', category: 'mobs', rarity: 'rare', stat: '30 HP' },
  { id: 'm3', name: 'Enderman', emoji: '🖤', category: 'mobs', rarity: 'epic', stat: '40 HP' },
  { id: 'm4', name: 'Drache', emoji: '🐉', category: 'mobs', rarity: 'legendary', stat: '200 HP' },
  // Food (echte IDs aus vanilla_stats.json)
  { id: 'golden_apple', name: 'Goldener Apfel', emoji: '🍎', category: 'food', rarity: 'rare', stat: '4 🍗' },
  { id: 'cooked_beef', name: 'Steak', emoji: '🥩', category: 'food', rarity: 'common', stat: '8 🍗' },
  { id: 'cooked_porkchop', name: 'Gebr. Schweinefleisch', emoji: '🍖', category: 'food', rarity: 'common', stat: '8 🍗' },
  { id: 'bread', name: 'Brot', emoji: '🍞', category: 'food', rarity: 'common', stat: '5 🍗' },
  { id: 'apple', name: 'Apfel', emoji: '🍎', category: 'food', rarity: 'common', stat: '4 🍗' },
  { id: 'cooked_chicken', name: 'Gebr. Hühnchen', emoji: '🍗', category: 'food', rarity: 'common', stat: '6 🍗' },
  { id: 'cooked_salmon', name: 'Gebr. Lachs', emoji: '🐟', category: 'food', rarity: 'common', stat: '6 🍗' },
  { id: 'carrot', name: 'Karotte', emoji: '🥕', category: 'food', rarity: 'common', stat: '3 🍗' },
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
