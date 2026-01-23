/**
 * Design System - B2B Professional Theme
 * Centralized styles, colors, fonts, and components
 */

// ============================================================================
// COLORS
// ============================================================================
export const colors = {
  // Neutrals
  black: "#000000",
  darkGray: "#1a1a1a",
  gray: "#666666",
  lightGray: "#f5f5f5",
  borderGray: "#e0e0e0",
  white: "#ffffff",

  // Primary (Trust Blue)
  primary: "#0066cc",
  primaryLight: "#e6f0ff",
  primaryDark: "#004499",

  // Status colors
  success: "#28a745",
  successLight: "#e8f5e9",
  warning: "#ff9800",
  warningLight: "#fff3e0",
  error: "#d32f2f",
  errorLight: "#ffebee",
  info: "#1976d2",
  infoLight: "#e3f2fd",

  // Text
  textPrimary: "#1a1a1a",
  textSecondary: "#666666",
  textDisabled: "#999999",
  textInverse: "#ffffff",

  // Background
  bgPrimary: "#ffffff",
  bgSecondary: "#f5f5f5",
  bgTertiary: "#eeeeee",
};

// ============================================================================
// TYPOGRAPHY
// ============================================================================
export const fonts = {
  // Font families
  family: {
    primary: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", sans-serif',
  },

  // Font sizes
  size: {
    xs: "12px",
    sm: "14px",
    body: "16px",
    lg: "18px",
    xl: "20px",
    h3: "24px",
    h2: "32px",
    h1: "40px",
  },

  // Font weights
  weight: {
    normal: 400,
    medium: 500,
    semibold: 600,
    bold: 700,
  },

  // Line heights
  lineHeight: {
    tight: 1.2,
    normal: 1.5,
    relaxed: 1.75,
  },
};

// ============================================================================
// SPACING
// ============================================================================
export const spacing = {
  xs: "4px",
  sm: "8px",
  md: "12px",
  lg: "16px",
  xl: "20px",
  xxl: "24px",
  "3xl": "32px",
  "4xl": "40px",
  "5xl": "48px",
};

// ============================================================================
// BORDER RADIUS
// ============================================================================
export const borderRadius = {
  none: "0px",
  sm: "4px",
  md: "6px",
  lg: "8px",
  xl: "12px",
};

// ============================================================================
// SHADOWS
// ============================================================================
export const shadows = {
  none: "none",
  sm: "0 1px 2px rgba(0, 0, 0, 0.05)",
  md: "0 2px 8px rgba(0, 0, 0, 0.1)",
  lg: "0 4px 12px rgba(0, 0, 0, 0.15)",
  xl: "0 8px 24px rgba(0, 0, 0, 0.12)",
};

// ============================================================================
// COMPONENTS - BUTTONS
// ============================================================================
export const buttonStyles = {
  primary: {
    padding: `${spacing.md} ${spacing.lg}`,
    backgroundColor: colors.primary,
    color: colors.textInverse,
    border: "none",
    borderRadius: borderRadius.md,
    fontFamily: fonts.family.primary,
    fontSize: fonts.size.body,
    fontWeight: fonts.weight.semibold,
    cursor: "pointer",
    transition: "all 0.2s ease",
    boxShadow: shadows.sm,
  },

  secondary: {
    padding: `${spacing.md} ${spacing.lg}`,
    backgroundColor: colors.white,
    color: colors.primary,
    border: `1px solid ${colors.borderGray}`,
    borderRadius: borderRadius.md,
    fontFamily: fonts.family.primary,
    fontSize: fonts.size.body,
    fontWeight: fonts.weight.semibold,
    cursor: "pointer",
    transition: "all 0.2s ease",
    boxShadow: shadows.sm,
  },

  ghost: {
    padding: `${spacing.md} ${spacing.lg}`,
    backgroundColor: "transparent",
    color: colors.primary,
    border: "none",
    borderRadius: borderRadius.md,
    fontFamily: fonts.family.primary,
    fontSize: fonts.size.body,
    fontWeight: fonts.weight.semibold,
    cursor: "pointer",
    transition: "all 0.2s ease",
  },

  danger: {
    padding: `${spacing.md} ${spacing.lg}`,
    backgroundColor: colors.error,
    color: colors.textInverse,
    border: "none",
    borderRadius: borderRadius.md,
    fontFamily: fonts.family.primary,
    fontSize: fonts.size.body,
    fontWeight: fonts.weight.semibold,
    cursor: "pointer",
    transition: "all 0.2s ease",
    boxShadow: shadows.sm,
  },

  success: {
    padding: `${spacing.md} ${spacing.lg}`,
    backgroundColor: colors.success,
    color: colors.textInverse,
    border: "none",
    borderRadius: borderRadius.md,
    fontFamily: fonts.family.primary,
    fontSize: fonts.size.body,
    fontWeight: fonts.weight.semibold,
    cursor: "pointer",
    transition: "all 0.2s ease",
    boxShadow: shadows.sm,
  },
};

// ============================================================================
// COMPONENTS - INPUTS
// ============================================================================
export const inputStyles = {
  base: {
    padding: `${spacing.md}`,
    border: `1px solid ${colors.borderGray}`,
    borderRadius: borderRadius.md,
    fontFamily: fonts.family.primary,
    fontSize: fonts.size.body,
    color: colors.textPrimary,
    transition: "border-color 0.2s ease",
    width: "100%",
    boxSizing: "border-box" as const,
  },

  focus: {
    borderColor: colors.primary,
    outlineColor: colors.primaryLight,
    boxShadow: `0 0 0 3px ${colors.primaryLight}`,
  },

  error: {
    borderColor: colors.error,
    boxShadow: `0 0 0 3px ${colors.errorLight}`,
  },
};

// ============================================================================
// COMPONENTS - CARDS
// ============================================================================
export const cardStyles = {
  base: {
    backgroundColor: colors.bgPrimary,
    border: `1px solid ${colors.borderGray}`,
    borderRadius: borderRadius.lg,
    padding: spacing.lg,
    boxShadow: shadows.md,
  },

  hover: {
    boxShadow: shadows.lg,
    transition: "box-shadow 0.2s ease",
  },
};

// ============================================================================
// ============================================================================
// CONTAINERS & LAYOUTS
// ============================================================================
export const layouts = {
  container: {
    maxWidth: "1200px",
    margin: "0 auto",
    padding: `0 ${spacing.lg}`,
  },

  pageContent: {
    minHeight: "100vh",
    backgroundColor: colors.bgPrimary,
    padding: spacing.xl,
  },

  centerBox: {
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    minHeight: "100vh",
  },
};

// ============================================================================
// TYPOGRAPHY - HEADING STYLES
// ============================================================================
export const headingStyles = {
  h1: {
    fontSize: fonts.size.h1,
    fontWeight: fonts.weight.bold,
    lineHeight: fonts.lineHeight.tight,
    color: colors.textPrimary,
    margin: 0,
  },

  h2: {
    fontSize: fonts.size.h2,
    fontWeight: fonts.weight.bold,
    lineHeight: fonts.lineHeight.tight,
    color: colors.textPrimary,
    margin: 0,
  },

  h3: {
    fontSize: fonts.size.h3,
    fontWeight: fonts.weight.semibold,
    lineHeight: fonts.lineHeight.tight,
    color: colors.textPrimary,
    margin: 0,
  },
};

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

export function getCSSVar(name: string, fallback: string = "") {
  return `var(--${name}, ${fallback})`;
}

export function mergeStyles(...styles: any[]) {
  return Object.assign({}, ...styles);
}
