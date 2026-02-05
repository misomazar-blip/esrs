"use client";

import { colors, buttonStyles, inputStyles, cardStyles, fonts, spacing, shadows, borderRadius } from "@/lib/styles";
import { useState } from "react";

export default function ShowcasePage() {
  const [inputValue, setInputValue] = useState("");

  return (
    <div style={{ padding: spacing.xl, backgroundColor: colors.bgSecondary, minHeight: "100vh" }}>
      <div style={{ maxWidth: "1200px", margin: "0 auto" }}>
        <h1 style={{ fontSize: fonts.size.h1, fontWeight: fonts.weight.bold, marginBottom: spacing.xl }}>
          Design System Showcase
        </h1>

        {/* ============ COLORS ============ */}
        <section style={{ marginBottom: spacing.xxl }}>
          <h2 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, marginBottom: spacing.lg }}>
            Colors
          </h2>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(150px, 1fr))", gap: spacing.md }}>
            {Object.entries(colors).map(([name, color]) => (
              <div key={name} style={{ ...cardStyles.base }}>
                <div
                  style={{
                    width: "100%",
                    height: "80px",
                    backgroundColor: color,
                    borderRadius: borderRadius.md,
                    marginBottom: spacing.md,
                    border: `1px solid ${colors.borderGray}`,
                  }}
                />
                <p style={{ fontSize: fonts.size.sm, margin: 0, marginBottom: spacing.sm }}>
                  <strong>{name}</strong>
                </p>
                <p style={{ fontSize: fonts.size.xs, color: colors.textSecondary, margin: 0 }}>
                  {color}
                </p>
              </div>
            ))}
          </div>
        </section>

        {/* ============ TYPOGRAPHY ============ */}
        <section style={{ marginBottom: spacing.xxl }}>
          <h2 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, marginBottom: spacing.lg }}>
            Typography
          </h2>
          <div style={{ ...cardStyles.base }}>
            <div style={{ marginBottom: spacing.lg }}>
              <h3 style={{ fontSize: fonts.size.h3, fontWeight: fonts.weight.bold }}>Heading H1 (40px)</h3>
              <p style={{ fontSize: fonts.size.h1, margin: 0, color: colors.textSecondary }}>
                The quick brown fox jumps over the lazy dog
              </p>
            </div>

            <div style={{ marginBottom: spacing.lg }}>
              <h3 style={{ fontSize: fonts.size.h3, fontWeight: fonts.weight.bold }}>Heading H2 (32px)</h3>
              <p style={{ fontSize: fonts.size.h2, margin: 0, color: colors.textSecondary }}>
                The quick brown fox jumps over the lazy dog
              </p>
            </div>

            <div style={{ marginBottom: spacing.lg }}>
              <h3 style={{ fontSize: fonts.size.h3, fontWeight: fonts.weight.bold }}>Heading H3 (24px)</h3>
              <p style={{ fontSize: fonts.size.h3, margin: 0, color: colors.textSecondary }}>
                The quick brown fox jumps over the lazy dog
              </p>
            </div>

            <div style={{ marginBottom: spacing.lg }}>
              <h4 style={{ fontSize: fonts.size.body, fontWeight: fonts.weight.bold }}>Body Text (16px)</h4>
              <p style={{ fontSize: fonts.size.body, margin: 0, color: colors.textSecondary, lineHeight: fonts.lineHeight.normal }}>
                The quick brown fox jumps over the lazy dog. This is a standard body text size for reading.
              </p>
            </div>

            <div style={{ marginBottom: spacing.lg }}>
              <h4 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold }}>Large Text (18px)</h4>
              <p style={{ fontSize: fonts.size.lg, margin: 0, color: colors.textSecondary }}>
                The quick brown fox jumps over the lazy dog
              </p>
            </div>

            <div style={{ marginBottom: spacing.lg }}>
              <h4 style={{ fontSize: fonts.size.sm, fontWeight: fonts.weight.bold }}>Small Text (14px)</h4>
              <p style={{ fontSize: fonts.size.sm, margin: 0, color: colors.textSecondary }}>
                The quick brown fox jumps over the lazy dog
              </p>
            </div>

            <div>
              <h4 style={{ fontSize: fonts.size.xs, fontWeight: fonts.weight.bold }}>Extra Small Text (12px)</h4>
              <p style={{ fontSize: fonts.size.xs, margin: 0, color: colors.textSecondary }}>
                The quick brown fox jumps over the lazy dog
              </p>
            </div>
          </div>
        </section>

        {/* ============ BUTTONS ============ */}
        <section style={{ marginBottom: spacing.xxl }}>
          <h2 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, marginBottom: spacing.lg }}>
            Buttons
          </h2>
          <div style={{ ...cardStyles.base, display: "grid", gap: spacing.lg }}>
            <div>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.semibold, marginBottom: spacing.md }}>
                Primary Button
              </h3>
              <button style={buttonStyles.primary}>Primary Button</button>
              <button style={{ ...buttonStyles.primary, opacity: 0.6, cursor: "not-allowed" }} disabled>
                Disabled Primary
              </button>
            </div>

            <div>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.semibold, marginBottom: spacing.md }}>
                Secondary Button
              </h3>
              <button style={buttonStyles.secondary}>Secondary Button</button>
              <button style={{ ...buttonStyles.secondary, opacity: 0.6, cursor: "not-allowed" }} disabled>
                Disabled Secondary
              </button>
            </div>

            <div>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.semibold, marginBottom: spacing.md }}>
                Ghost Button
              </h3>
              <button style={buttonStyles.ghost}>Ghost Button</button>
              <button style={{ ...buttonStyles.ghost, opacity: 0.6, cursor: "not-allowed" }} disabled>
                Disabled Ghost
              </button>
            </div>

            <div>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.semibold, marginBottom: spacing.md }}>
                Success Button
              </h3>
              <button style={buttonStyles.success}>Success Button</button>
            </div>

            <div>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.semibold, marginBottom: spacing.md }}>
                Danger Button
              </h3>
              <button style={buttonStyles.danger}>Danger Button</button>
            </div>
          </div>
        </section>

        {/* ============ INPUTS ============ */}
        <section style={{ marginBottom: spacing.xxl }}>
          <h2 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, marginBottom: spacing.lg }}>
            Inputs
          </h2>
          <div style={{ ...cardStyles.base, display: "grid", gap: spacing.lg, maxWidth: "400px" }}>
            <div>
              <label style={{ display: "block", marginBottom: spacing.sm, fontWeight: fonts.weight.semibold }}>
                Default Input
              </label>
              <input
                type="text"
                placeholder="Type something..."
                style={inputStyles.base}
                value={inputValue}
                onChange={(e) => setInputValue(e.target.value)}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.sm, fontWeight: fonts.weight.semibold }}>
                Email Input
              </label>
              <input type="email" placeholder="example@email.com" style={inputStyles.base} />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.sm, fontWeight: fonts.weight.semibold }}>
                Password Input
              </label>
              <input type="password" placeholder="Enter password" style={inputStyles.base} />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.sm, fontWeight: fonts.weight.semibold }}>
                Error Input
              </label>
              <input type="text" placeholder="This has an error" style={{ ...inputStyles.base, ...inputStyles.error }} />
              <p style={{ fontSize: fonts.size.sm, color: colors.error, marginTop: spacing.sm }}>
                This field is required
              </p>
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.sm, fontWeight: fonts.weight.semibold }}>
                Disabled Input
              </label>
              <input type="text" placeholder="Disabled" style={{ ...inputStyles.base, opacity: 0.6 }} disabled />
            </div>
          </div>
        </section>

        {/* ============ CARDS ============ */}
        <section style={{ marginBottom: spacing.xxl }}>
          <h2 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, marginBottom: spacing.lg }}>
            Cards
          </h2>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))", gap: spacing.lg }}>
            {[1, 2, 3].map((i) => (
              <div key={i} style={cardStyles.base}>
                <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginBottom: spacing.md }}>
                  Card {i}
                </h3>
                <p style={{ color: colors.textSecondary, marginBottom: spacing.md }}>
                  This is a sample card demonstrating the card styling from our design system.
                </p>
                <div style={{ display: "flex", gap: spacing.sm }}>
                  <button style={buttonStyles.primary}>Action</button>
                  <button style={buttonStyles.secondary}>Cancel</button>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* ============ SPACING ============ */}
        <section style={{ marginBottom: spacing.xxl }}>
          <h2 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, marginBottom: spacing.lg }}>
            Spacing
          </h2>
          <div style={cardStyles.base}>
            {Object.entries(spacing).map(([name, value]) => (
              <div key={name} style={{ marginBottom: spacing.lg, display: "flex", alignItems: "center", gap: spacing.lg }}>
                <div style={{ minWidth: "80px" }}>
                  <strong>{name}</strong> = {value}
                </div>
                <div
                  style={{
                    height: "30px",
                    backgroundColor: colors.primary,
                    width: value,
                    borderRadius: borderRadius.sm,
                  }}
                />
              </div>
            ))}
          </div>
        </section>

        {/* ============ SHADOWS ============ */}
        <section style={{ marginBottom: spacing.xxl }}>
          <h2 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, marginBottom: spacing.lg }}>
            Shadows
          </h2>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(150px, 1fr))", gap: spacing.lg }}>
            {Object.entries(shadows).map(([name, shadow]) => (
              <div
                key={name}
                style={{
                  padding: spacing.lg,
                  backgroundColor: colors.white,
                  borderRadius: borderRadius.lg,
                  boxShadow: shadow,
                  textAlign: "center",
                }}
              >
                <p style={{ margin: 0, fontWeight: fonts.weight.semibold }}>
                  {name}
                </p>
              </div>
            ))}
          </div>
        </section>

        {/* ============ BORDER RADIUS ============ */}
        <section style={{ marginBottom: spacing.xxl }}>
          <h2 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, marginBottom: spacing.lg }}>
            Border Radius
          </h2>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(150px, 1fr))", gap: spacing.lg }}>
            {Object.entries(borderRadius).map(([name, radius]) => (
              <div key={name} style={{ textAlign: "center" }}>
                <div
                  style={{
                    width: "100px",
                    height: "100px",
                    backgroundColor: colors.primary,
                    borderRadius: radius,
                    margin: "0 auto " + spacing.md,
                  }}
                />
                <p style={{ margin: 0, fontWeight: fonts.weight.semibold }}>
                  {name}
                </p>
                <p style={{ fontSize: fonts.size.xs, color: colors.textSecondary, margin: 0 }}>
                  {radius}
                </p>
              </div>
            ))}
          </div>
        </section>
      </div>
    </div>
  );
}
