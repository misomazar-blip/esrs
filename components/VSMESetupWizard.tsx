"use client";

import React, { useState, useMemo } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import {
  colors,
  buttonStyles,
  inputStyles,
  cardStyles,
  fonts,
  spacing,
  shadows,
} from "@/lib/styles";
import {
  updateCompanyEmployeeCount,
  validateEmployeeCount,
  formatVSMEProgress
} from "@/lib/vsmeQuestions";

export interface VSMESetupWizardProps {
  companyId: string;
  currentEmployeeCount?: number | null;
  onComplete?: (employeeCount: number) => void;
  onSkip?: () => void;
}

export default function VSMESetupWizard({
  companyId,
  currentEmployeeCount,
  onComplete,
  onSkip,
}: VSMESetupWizardProps) {
  const supabase = createSupabaseBrowserClient();

  // State
  const [step, setStep] = useState<"instruction" | "employee-count" | "confirm" | "complete">(
    "instruction"
  );
  const [employeeCount, setEmployeeCount] = useState<string>(
    currentEmployeeCount?.toString() || ""
  );
  const [inputError, setInputError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  // Urči je firma VSME?
  const isVSME = useMemo(() => {
    const count = employeeCount ? parseInt(employeeCount) : null;
    return count !== null && count <= 750;
  }, [employeeCount]);

  // Zálomit sa na ďalší krok
  const handleNext = async () => {
    if (step === "instruction") {
      setStep("employee-count");
    } else if (step === "employee-count") {
      // Validuj
      const count = employeeCount ? parseInt(employeeCount) : null;
      const validation = validateEmployeeCount(count);

      if (!validation.valid) {
        setInputError(validation.error || "Chyba");
        return;
      }

      setInputError(null);
      setStep("confirm");
    } else if (step === "confirm") {
      // Ulož do databázy
      await handleSave();
    }
  };

  // Ulož employee_count
  const handleSave = async () => {
    try {
      setIsLoading(true);
      const count = parseInt(employeeCount);

      await updateCompanyEmployeeCount(companyId, count, supabase);

      setStep("complete");
      onComplete?.(count);
    } catch (err) {
      setInputError((err as Error).message || "Chyba pri ukladaní");
    } finally {
      setIsLoading(false);
    }
  };

  // Render: INSTRUCTION step
  if (step === "instruction") {
    return (
      <div
        style={{
          maxWidth: "600px",
          margin: "0 auto",
          padding: spacing.xl,
        }}
      >
        <div style={cardStyles.base}>
          <h1
            style={{
              fontSize: fonts.size.h2,
              fontWeight: fonts.weight.bold,
              color: colors.primary,
              marginBottom: spacing.lg,
            }}
          >
            🚀 Vitajte v ESRS Platforme
          </h1>

          <p
            style={{
              fontSize: fonts.size.md,
              color: colors.textMain,
              marginBottom: spacing.md,
              lineHeight: "1.6",
            }}
          >
            Táto platforma je špeciálne navrhnutá pre <strong>malé firmy</strong> a{" "}
            <strong>mikropodnikánie</strong> (VSME). Prispôsobí si otázky podľa
            veľkosti vašej firmy.
          </p>

          <div
            style={{
              backgroundColor: colors.bgSecondary,
              border: `2px solid ${colors.primary}`,
              borderRadius: "8px",
              padding: spacing.lg,
              marginBottom: spacing.lg,
            }}
          >
            <h3
              style={{
                fontSize: fonts.size.md,
                fontWeight: fonts.weight.semibold,
                marginBottom: spacing.sm,
                color: colors.primary,
              }}
            >
              ❓ Čo je VSME?
            </h3>
            <p style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>
              Firma so <strong>menej ako 750 zamestnancami</strong> v priemere počas
              finančného roka. Ak ste VSME, máte:
            </p>
            <ul
              style={{
                marginTop: spacing.sm,
                marginLeft: spacing.lg,
                fontSize: fonts.size.sm,
                color: colors.textSecondary,
                lineHeight: "1.8",
              }}
            >
              <li>✅ Zjednoduené otázky</li>
              <li>✅ Fázované zavádzanie (nie všetko v 1. roku)</li>
              <li>✅ Menej administratívy</li>
              <li>✅ Jednoduchší export report</li>
            </ul>
          </div>

          <p
            style={{
              fontSize: fonts.size.sm,
              color: colors.textSecondary,
              marginBottom: spacing.lg,
              fontStyle: "italic",
            }}
          >
            💡 <strong>Tip:</strong> Veľkosť firmy určujú {" "}
            <u>
              priemerní zamestnanci počas finančného roka
            </u>
            , nie aktuálny počet.
          </p>

          <div style={{ display: "flex", gap: spacing.md, justifyContent: "flex-end" }}>
            <button
              onClick={onSkip}
              style={{
                ...buttonStyles.secondary,
                cursor: "pointer",
              }}
            >
              Preskočiť
            </button>
            <button
              onClick={handleNext}
              style={{
                ...buttonStyles.primary,
                cursor: "pointer",
              }}
            >
              Pokračovať →
            </button>
          </div>
        </div>
      </div>
    );
  }

  // Render: EMPLOYEE COUNT step
  if (step === "employee-count") {
    return (
      <div
        style={{
          maxWidth: "600px",
          margin: "0 auto",
          padding: spacing.xl,
        }}
      >
        <div style={cardStyles.base}>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: spacing.sm,
              marginBottom: spacing.lg,
            }}
          >
            <span
              style={{
                fontSize: fonts.size.xl,
                fontWeight: fonts.weight.bold,
                color: colors.textSecondary,
              }}
            >
              Krok 1/2
            </span>
            <div
              style={{
                flex: 1,
                height: "4px",
                backgroundColor: colors.bgSecondary,
                borderRadius: "2px",
                overflow: "hidden",
              }}
            >
              <div
                style={{
                  width: "50%",
                  height: "100%",
                  backgroundColor: colors.primary,
                  transition: "width 0.3s ease",
                }}
              />
            </div>
          </div>

          <h2
            style={{
              fontSize: fonts.size.h3,
              fontWeight: fonts.weight.bold,
              marginBottom: spacing.lg,
              color: colors.textMain,
            }}
          >
            Koľko máte zamestnancov?
          </h2>

          <p
            style={{
              fontSize: fonts.size.sm,
              color: colors.textSecondary,
              marginBottom: spacing.md,
            }}
          >
            Zadajte <strong>priemerný počet zamestnancov</strong> počas vášho
            finančného roka.
          </p>

          <div style={{ marginBottom: spacing.lg }}>
            <label
              style={{
                display: "block",
                fontSize: fonts.size.sm,
                fontWeight: fonts.weight.semibold,
                marginBottom: spacing.sm,
                color: colors.textMain,
              }}
            >
              Počet zamestnancov (FTE)
            </label>
            <input
              type="number"
              min="1"
              value={employeeCount}
              onChange={(e) => {
                setEmployeeCount(e.target.value);
                setInputError(null);
              }}
              onKeyPress={(e) => {
                if (e.key === "Enter") handleNext();
              }}
              placeholder="napr. 45"
              style={{
                ...inputStyles.default,
                fontSize: fonts.size.md,
                padding: spacing.md,
                width: "100%",
                borderColor: inputError ? colors.alerts.error : colors.border,
              }}
              autoFocus
            />

            {inputError && (
              <p
                style={{
                  color: colors.alerts.error,
                  fontSize: fonts.size.sm,
                  marginTop: spacing.sm,
                }}
              >
                ⚠️ {inputError}
              </p>
            )}
          </div>

          {/* VSME Status Preview */}
          {employeeCount && (
            <div
              style={{
                backgroundColor: isVSME ? "#DBEAFE" : "#FEF3C7",
                border: `2px solid ${isVSME ? colors.primary : "#FBBF24"}`,
                borderRadius: "8px",
                padding: spacing.md,
                marginBottom: spacing.lg,
              }}
            >
              <p
                style={{
                  fontSize: fonts.size.sm,
                  fontWeight: fonts.weight.semibold,
                  color: isVSME ? colors.primary : "#B45309",
                }}
              >
                {isVSME ? (
                  <>✅ Ste VSME - budete mať zjednoduené otázky</>
                ) : (
                  <>⚠️ Nie ste VSME - budete mať kompletný ESRS sada otázok</>
                )}
              </p>
            </div>
          )}

          <div style={{ display: "flex", gap: spacing.md, justifyContent: "flex-end" }}>
            <button
              onClick={() => setStep("instruction")}
              style={{
                ...buttonStyles.secondary,
                cursor: "pointer",
              }}
            >
              ← Späť
            </button>
            <button
              onClick={handleNext}
              disabled={!employeeCount}
              style={{
                ...buttonStyles.primary,
                cursor: employeeCount ? "pointer" : "not-allowed",
                opacity: employeeCount ? 1 : 0.5,
              }}
            >
              Pokračovať →
            </button>
          </div>
        </div>
      </div>
    );
  }

  // Render: CONFIRM step
  if (step === "confirm") {
    const count = parseInt(employeeCount);

    return (
      <div
        style={{
          maxWidth: "600px",
          margin: "0 auto",
          padding: spacing.xl,
        }}
      >
        <div style={cardStyles.base}>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: spacing.sm,
              marginBottom: spacing.lg,
            }}
          >
            <span
              style={{
                fontSize: fonts.size.xl,
                fontWeight: fonts.weight.bold,
                color: colors.textSecondary,
              }}
            >
              Krok 2/2
            </span>
            <div
              style={{
                flex: 1,
                height: "4px",
                backgroundColor: colors.bgSecondary,
                borderRadius: "2px",
                overflow: "hidden",
              }}
            >
              <div
                style={{
                  width: "100%",
                  height: "100%",
                  backgroundColor: colors.primary,
                  transition: "width 0.3s ease",
                }}
              />
            </div>
          </div>

          <h2
            style={{
              fontSize: fonts.size.h3,
              fontWeight: fonts.weight.bold,
              marginBottom: spacing.lg,
              color: colors.textMain,
            }}
          >
            Potvrď Údaje
          </h2>

          <div
            style={{
              backgroundColor: colors.bgSecondary,
              borderRadius: "8px",
              padding: spacing.lg,
              marginBottom: spacing.lg,
            }}
          >
            <div
              style={{
                display: "grid",
                gridTemplateColumns: "1fr 1fr",
                gap: spacing.lg,
              }}
            >
              <div>
                <p
                  style={{
                    fontSize: fonts.size.sm,
                    color: colors.textSecondary,
                    marginBottom: spacing.xs,
                  }}
                >
                  Počet zamestnancov
                </p>
                <p
                  style={{
                    fontSize: fonts.size.lg,
                    fontWeight: fonts.weight.bold,
                    color: colors.textMain,
                  }}
                >
                  {count.toLocaleString("sk-SK")}
                </p>
              </div>

              <div>
                <p
                  style={{
                    fontSize: fonts.size.sm,
                    color: colors.textSecondary,
                    marginBottom: spacing.xs,
                  }}
                >
                  Status
                </p>
                <p
                  style={{
                    fontSize: fonts.size.lg,
                    fontWeight: fonts.weight.bold,
                    color: isVSME ? colors.success : colors.warning,
                  }}
                >
                  {isVSME ? "VSME" : "Large Company"}
                </p>
              </div>
            </div>

            {isVSME && (
              <div
                style={{
                  marginTop: spacing.lg,
                  paddingTop: spacing.lg,
                  borderTop: `1px solid ${colors.border}`,
                }}
              >
                <h4
                  style={{
                    fontSize: fonts.size.sm,
                    fontWeight: fonts.weight.semibold,
                    marginBottom: spacing.sm,
                    color: colors.primary,
                  }}
                >
                  ✨ Vaše výhody ako VSME:
                </h4>
                <ul
                  style={{
                    fontSize: fonts.size.sm,
                    color: colors.textSecondary,
                    marginLeft: spacing.lg,
                    lineHeight: "1.8",
                  }}
                >
                  <li>✅ Menej otázok (nie všetko hneď)</li>
                  <li>✅ Postupné zavádzanie v nasledujúcich rokoch</li>
                  <li>✅ Zjednoduené vykazovanie</li>
                  <li>✅ Inteligentný sprievodca</li>
                </ul>
              </div>
            )}
          </div>

          <label
            style={{
              display: "flex",
              alignItems: "center",
              gap: spacing.sm,
              marginBottom: spacing.lg,
              cursor: "pointer",
            }}
          >
            <input
              type="checkbox"
              defaultChecked
              style={{ width: "18px", height: "18px", cursor: "pointer" }}
            />
            <span
              style={{
                fontSize: fonts.size.sm,
                color: colors.textMain,
              }}
            >
              Potvrdzujem, že je to správny počet zamestnancov
            </span>
          </label>

          <div style={{ display: "flex", gap: spacing.md, justifyContent: "flex-end" }}>
            <button
              onClick={() => setStep("employee-count")}
              style={{
                ...buttonStyles.secondary,
                cursor: "pointer",
              }}
            >
              ← Späť
            </button>
            <button
              onClick={handleNext}
              disabled={isLoading}
              style={{
                ...buttonStyles.primary,
                cursor: isLoading ? "not-allowed" : "pointer",
                opacity: isLoading ? 0.6 : 1,
              }}
            >
              {isLoading ? "Ukladám..." : "Potvrdiť a Pokračovať →"}
            </button>
          </div>
        </div>
      </div>
    );
  }

  // Render: COMPLETE step
  if (step === "complete") {
    return (
      <div
        style={{
          maxWidth: "600px",
          margin: "0 auto",
          padding: spacing.xl,
        }}
      >
        <div style={cardStyles.base}>
          <div
            style={{
              textAlign: "center",
              paddingBottom: spacing.xl,
            }}
          >
            <div
              style={{
                fontSize: "64px",
                marginBottom: spacing.lg,
              }}
            >
              ✨
            </div>

            <h2
              style={{
                fontSize: fonts.size.h2,
                fontWeight: fonts.weight.bold,
                color: colors.primary,
                marginBottom: spacing.md,
              }}
            >
              Všetko je nastavené!
            </h2>

            <p
              style={{
                fontSize: fonts.size.md,
                color: colors.textSecondary,
                marginBottom: spacing.lg,
              }}
            >
              Vaša firma je konfigurovaná ako{" "}
              <strong>{isVSME ? "VSME" : "Veľká firma"}</strong>.
            </p>

            <div
              style={{
                backgroundColor: colors.bgSecondary,
                borderRadius: "8px",
                padding: spacing.lg,
                marginBottom: spacing.xl,
              }}
            >
              <p
                style={{
                  fontSize: fonts.size.sm,
                  color: colors.textSecondary,
                  marginBottom: spacing.sm,
                }}
              >
                🎯 <strong>Ďalej budete odpoveďovat na otázky</strong> podľa
              </p>
              <p
                style={{
                  fontSize: fonts.size.lg,
                  fontWeight: fonts.weight.bold,
                  color: colors.primary,
                }}
              >
                ESRS {isVSME ? "VSME" : "Full"}
              </p>
            </div>

            <button
              onClick={onComplete}
              style={{
                ...buttonStyles.primary,
                cursor: "pointer",
                fontSize: fonts.size.md,
                padding: `${spacing.md} ${spacing.xl}`,
              }}
            >
              Začať s otázkami 🚀
            </button>
          </div>
        </div>
      </div>
    );
  }

  return null;
}
