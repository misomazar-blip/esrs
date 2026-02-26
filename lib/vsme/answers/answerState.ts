export type DisclosureAnswerRow = {
  question_id: string;
  value_text?: string | null;
  value_boolean?: boolean | null;
  value_integer?: number | null;
  value_numeric?: number | null;
  value_number?: any | null;
  value_date?: string | null;
  value_json?: any | null;
  value_jsonb?: any;
  unit?: string | null;
};

export function isNaRow(a: DisclosureAnswerRow | undefined): boolean {
  return a?.value_jsonb?.na === true || a?.value_jsonb?.na === "true";
}

export function hasMeaningfulValue(a: DisclosureAnswerRow | undefined): boolean {
  if (!a) return false;
  if (isNaRow(a)) return false;

  if (typeof a.value_text === "string" && a.value_text.trim() !== "") return true;
  if (a.value_boolean !== null && a.value_boolean !== undefined) return true;
  if (a.value_integer !== null && a.value_integer !== undefined) return true;
  if (a.value_numeric !== null && a.value_numeric !== undefined) return true;
  if (a.value_number !== null && a.value_number !== undefined) return true;
  if (a.value_date !== null && a.value_date !== undefined && String(a.value_date).trim() !== "") return true;
  if (a.value_json && typeof a.value_json === "object" && Object.keys(a.value_json).length > 0) return true;
  if (
    a.value_jsonb &&
    typeof a.value_jsonb === "object" &&
    Object.keys(a.value_jsonb).length > 0 &&
    !(Object.keys(a.value_jsonb).length === 1 && "na" in a.value_jsonb)
  )
    return true;

  return false;
}

export function getStatus(a: DisclosureAnswerRow | undefined): "missing" | "na" | "answered" {
  if (!a) return "missing";
  if (isNaRow(a)) return "na";
  if (hasMeaningfulValue(a)) return "answered";
  return "missing";
}
