/**
 * SnapSlider - Intelligenter Slider mit Snap-to-Default Feature
 *
 * Features:
 * - Rastet am Standardwert ein (±0.5 Toleranz)
 * - Haptic Feedback (Vibration) beim Einrasten
 * - Visuelle Markierung des Standardwerts
 * - Anzeige von aktueller Wert / Standardwert
 */

import React, { useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import Slider from '@react-native-community/slider';
import { colors } from '../theme/colors';

interface SnapSliderProps {
  label: string;
  emoji: string;
  value: number;
  defaultValue: number;
  minValue: number;
  maxValue: number;
  step?: number;
  onValueChange: (value: number) => void;
  unit?: string; // z.B. "❤️" für Gesundheit, "" für Schaden
}

export const SnapSlider: React.FC<SnapSliderProps> = ({
  label,
  emoji,
  value,
  defaultValue,
  minValue,
  maxValue,
  step = 0.1,
  onValueChange,
  unit = ''
}) => {
  const [lastSnapped, setLastSnapped] = useState(false);

  // Snap-Logik
  const handleValueChange = (newValue: number) => {
    const snapThreshold = 0.5;
    const distanceFromDefault = Math.abs(newValue - defaultValue);

    if (distanceFromDefault < snapThreshold && !lastSnapped) {
      // Snap zum Standardwert (ohne Vibration)
      setLastSnapped(true);
      onValueChange(defaultValue);
    } else if (distanceFromDefault >= snapThreshold) {
      // Weg vom Standardwert - snap deaktivieren
      setLastSnapped(false);
      onValueChange(newValue);
    } else if (lastSnapped && distanceFromDefault < snapThreshold) {
      // Bleib am Standardwert
      onValueChange(defaultValue);
    } else {
      onValueChange(newValue);
    }
  };

  // Formatierung der Werte
  const formatValue = (val: number): string => {
    // Wenn der Wert sehr groß ist (z.B. Haltbarkeit > 100), zeige Integer
    if (maxValue > 100) {
      return Math.round(val).toString();
    }
    // Ansonsten zeige 1 Dezimalstelle
    return val.toFixed(1);
  };

  // Prüfe ob Wert modifiziert wurde
  const isModified = Math.abs(value - defaultValue) > 0.05;

  // Berechne Position des Standard-Markers
  const defaultPosition = ((defaultValue - minValue) / (maxValue - minValue)) * 100;

  return (
    <View style={styles.container}>
      {/* Header mit Label und Werten */}
      <View style={styles.header}>
        <Text style={styles.label}>
          {emoji} {label}
        </Text>
        <Text style={[styles.value, isModified && styles.valueModified]}>
          {formatValue(value)} {unit}
          {isModified && <Text style={styles.defaultHint}> / {formatValue(defaultValue)}</Text>}
        </Text>
      </View>

      {/* Slider mit Standard-Marker */}
      <View style={styles.sliderContainer}>
        {/* Standard-Wert Markierung */}
        <View
          style={[
            styles.defaultMarker,
            { left: `${defaultPosition}%` }
          ]}
        />

        {/* Slider */}
        <Slider
          style={styles.slider}
          value={value}
          minimumValue={minValue}
          maximumValue={maxValue}
          step={step}
          onValueChange={handleValueChange}
          minimumTrackTintColor={isModified ? colors.info : colors.success}
          maximumTrackTintColor={colors.surface}
          thumbTintColor={colors.primary}
        />
      </View>

      {/* Info: Standardwert */}
      {!isModified && (
        <Text style={styles.hint}>Standard-Wert</Text>
      )}
      {isModified && (
        <Text style={styles.hintModified}>Angepasst</Text>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginBottom: 24,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  label: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.text,
  },
  value: {
    fontSize: 18,
    fontWeight: 'bold',
    color: colors.success,
  },
  valueModified: {
    color: colors.info,
  },
  defaultHint: {
    fontSize: 14,
    color: colors.textSecondary,
    fontWeight: 'normal',
  },
  sliderContainer: {
    position: 'relative',
    height: 40,
    justifyContent: 'center',
  },
  slider: {
    width: '100%',
    height: 40,
  },
  defaultMarker: {
    position: 'absolute',
    top: '50%',
    marginTop: -10,
    width: 3,
    height: 20,
    backgroundColor: colors.success,
    borderRadius: 2,
    zIndex: 1,
    opacity: 0.7,
  },
  hint: {
    fontSize: 12,
    color: colors.success,
    textAlign: 'center',
    marginTop: 4,
  },
  hintModified: {
    fontSize: 12,
    color: colors.info,
    textAlign: 'center',
    marginTop: 4,
  },
});
