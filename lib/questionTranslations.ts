// Helper functions for working with translated questions

/**
 * Gets the translated text for a question based on locale
 * Falls back to question_text if translation not available
 */
export function getQuestionText(
  question: { question_text: string; translations?: { [locale: string]: string } },
  locale: string
): string {
  // If translations exist and locale is available, use it
  if (question.translations && question.translations[locale]) {
    return question.translations[locale];
  }
  
  // Fallback to English if available
  if (question.translations && question.translations['en']) {
    return question.translations['en'];
  }
  
  // Final fallback to question_text field
  return question.question_text;
}

/**
 * Sets translation for a question
 */
export function setQuestionTranslation(
  currentTranslations: { [locale: string]: string } | undefined,
  locale: string,
  text: string
): { [locale: string]: string } {
  return {
    ...(currentTranslations || {}),
    [locale]: text
  };
}

/**
 * Gets all available locales for a question
 */
export function getAvailableLocales(
  question: { translations?: { [locale: string]: string } }
): string[] {
  return question.translations ? Object.keys(question.translations) : [];
}
