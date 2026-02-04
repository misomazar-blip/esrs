'use client';

import { VersionedQuestion, VersionedAnswer, DataType } from '@/types/esrs';
import { useState, useEffect } from 'react';

interface DynamicQuestionInputProps {
  question: VersionedQuestion;
  value?: VersionedAnswer;
  onChange: (value: Partial<VersionedAnswer>) => void;
  disabled?: boolean;
  showValidation?: boolean;
}

export default function DynamicQuestionInput({
  question,
  value,
  onChange,
  disabled = false,
  showValidation = false,
}: DynamicQuestionInputProps) {
  const dataType = question.data_type || 'narrative';
  const [validationError, setValidationError] = useState<string | null>(null);

  // Validate current value
  useEffect(() => {
    if (!showValidation) {
      setValidationError(null);
      return;
    }

    const error = validateValue();
    setValidationError(error);
  }, [value, showValidation]);

  const validateValue = (): string | null => {
    const currentValue = getCurrentValue();

    // Check if mandatory field is empty
    if (question.is_mandatory) {
      if (dataType === 'boolean') {
        // Boolean is always valid (can be true or false)
      } else if (dataType === 'narrative' || dataType === 'text') {
        if (!currentValue || (currentValue as string).trim() === '') {
          return 'Toto pole je povinné';
        }
      } else if (dataType === 'percentage' || dataType === 'percent' || 
                 dataType === 'monetary' || dataType === 'numeric' || 
                 dataType === 'integer') {
        if (currentValue === null || currentValue === undefined || currentValue === '') {
          return 'Toto pole je povinné';
        }
      } else if (dataType === 'date') {
        if (!currentValue || currentValue === '') {
          return 'Toto pole je povinné';
        }
      }
    }

    // Type-specific validation
    if (currentValue !== null && currentValue !== undefined && currentValue !== '') {
      switch (dataType) {
        case 'percentage':
        case 'percent':
          const percentValue = parseFloat(currentValue as string);
          if (isNaN(percentValue)) {
            return 'Neplatné číslo';
          }
          if (percentValue < 0 || percentValue > 100) {
            return 'Percento musí byť medzi 0 a 100';
          }
          break;

        case 'monetary':
          const monetaryValue = parseFloat(currentValue as string);
          if (isNaN(monetaryValue)) {
            return 'Neplatná suma';
          }
          if (monetaryValue < 0) {
            return 'Suma nemôže byť záporná';
          }
          break;

        case 'integer':
          const intValue = parseFloat(currentValue as string);
          if (isNaN(intValue)) {
            return 'Neplatné číslo';
          }
          if (!Number.isInteger(intValue)) {
            return 'Musí byť celé číslo';
          }
          break;

        case 'numeric':
          const numValue = parseFloat(currentValue as string);
          if (isNaN(numValue)) {
            return 'Neplatné číslo';
          }
          break;

        case 'date':
          const dateValue = currentValue as string;
          if (dateValue && !isValidDate(dateValue)) {
            return 'Neplatný dátum';
          }
          break;
      }
    }

    return null;
  };

  const isValidDate = (dateString: string): boolean => {
    const date = new Date(dateString);
    return date instanceof Date && !isNaN(date.getTime());
  };

  // Helper to update specific value field based on data type
  const handleChange = (newValue: any) => {
    const update: Partial<VersionedAnswer> = {};

    switch (dataType) {
      case 'narrative':
      case 'text':
        update.value_text = newValue;
        update.answer_text = newValue; // Backwards compatibility
        break;
      case 'percentage':
      case 'percent':
      case 'monetary':
      case 'numeric':
      case 'integer':
        update.value_numeric = newValue ? parseFloat(newValue) : null;
        update.unit = question.unit;
        break;
      case 'date':
        update.value_date = newValue;
        break;
      case 'boolean':
        update.value_boolean = newValue;
        break;
    }

    onChange(update);
  };

  // Get current value based on type
  const getCurrentValue = () => {
    if (!value) return '';

    switch (dataType) {
      case 'narrative':
      case 'text':
        return value.value_text || value.answer_text || '';
      case 'percentage':
      case 'percent':
      case 'monetary':
      case 'numeric':
      case 'integer':
        return value.value_numeric ?? '';
      case 'date':
        return value.value_date || '';
      case 'boolean':
        return value.value_boolean ?? false;
      default:
        return '';
    }
  };

  const currentValue = getCurrentValue();

  const hasError = showValidation && validationError !== null;
  const errorBorderClass = hasError ? 'border-red-500 focus:ring-red-500' : 'border-gray-200 focus:ring-blue-500';

  // Render different input based on data type
  const renderInput = () => {
    switch (dataType) {
      case 'narrative':
        return (
          <textarea
            value={currentValue as string}
            onChange={(e) => handleChange(e.target.value)}
            disabled={disabled}
            className={`w-full min-h-[120px] px-4 py-3 border rounded-lg focus:ring-2 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500 ${errorBorderClass}`}
            placeholder="Zadajte podrobný popis..."
          />
        );

      case 'text':
        return (
          <input
            type="text"
            value={currentValue as string}
            onChange={(e) => handleChange(e.target.value)}
            disabled={disabled}
            className={`w-full px-4 py-2 border rounded-lg focus:ring-2 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500 ${errorBorderClass}`}
            placeholder="Zadajte text..."
          />
        );

      case 'percentage':
      case 'percent':
        return (
          <div className="flex items-center gap-2">
            <input
              type="number"
              value={currentValue as number}
              onChange={(e) => handleChange(e.target.value)}
              disabled={disabled}
              min="0"
              max="100"
              step="0.01"
              className={`w-full px-4 py-2 border rounded-lg focus:ring-2 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500 ${errorBorderClass}`}
              placeholder="0.00"
            />
            <span className="text-gray-600 font-medium">%</span>
          </div>
        );

      case 'monetary':
        return (
          <div className="flex items-center gap-2">
            <input
              type="number"
              value={currentValue as number}
              onChange={(e) => handleChange(e.target.value)}
              disabled={disabled}
              min="0"
              step="0.01"
              className={`w-full px-4 py-2 border rounded-lg focus:ring-2 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500 ${errorBorderClass}`}
              placeholder="0.00"
            />
            <span className="text-gray-600 font-medium">€</span>
          </div>
        );

      case 'numeric':
      case 'integer':
        return (
          <div className="flex items-center gap-2">
            <input
              type="number"
              value={currentValue as number}
              onChange={(e) => handleChange(e.target.value)}
              disabled={disabled}
              step={dataType === 'integer' ? '1' : '0.01'}
              className={`w-full px-4 py-2 border rounded-lg focus:ring-2 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500 ${errorBorderClass}`}
              placeholder="0"
            />
            {question.unit && (
              <span className="text-gray-600 font-medium">{question.unit}</span>
            )}
          </div>
        );

      case 'date':
        return (
          <input
            type="date"
            value={currentValue as string}
            onChange={(e) => handleChange(e.target.value)}
            disabled={disabled}
            className={`w-full px-4 py-2 border rounded-lg focus:ring-2 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500 ${errorBorderClass}`}
          />
        );

      case 'boolean':
        return (
          <label className="flex items-center gap-3 cursor-pointer">
            <input
              type="checkbox"
              checked={currentValue as boolean}
              onChange={(e) => handleChange(e.target.checked)}
              disabled={disabled}
              className="w-5 h-5 text-blue-600 border-gray-300 rounded focus:ring-blue-500 disabled:opacity-50"
            />
            <span className="text-gray-700">
              {currentValue ? 'Áno' : 'Nie'}
            </span>
          </label>
        );

      default:
        return (
          <input
            type="text"
            value={currentValue as string}
            onChange={(e) => handleChange(e.target.value)}
            disabled={disabled}
            className={`w-full px-4 py-2 border rounded-lg focus:ring-2 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500 ${errorBorderClass}`}
          />
        );
    }
  };

  return (
    <div className="space-y-3">
      {/* Question Header */}
      <div className="flex items-start justify-between gap-4">
        <div className="flex-1">
          <div className="flex items-center gap-2 mb-1">
            {question.datapoint_id && (
              <span className="text-xs font-mono text-gray-500 bg-gray-100 px-2 py-0.5 rounded">
                {question.datapoint_id}
              </span>
            )}
            {question.is_mandatory && (
              <span className="text-xs font-medium text-red-600 bg-red-50 px-2 py-0.5 rounded">
                ★ Povinné
              </span>
            )}
            {!question.is_mandatory && (
              <span className="text-xs font-medium text-blue-600 bg-blue-50 px-2 py-0.5 rounded">
                Dobrovoľné
              </span>
            )}
          </div>
          <label className="text-sm font-medium text-gray-900">
            {question.question_text}
          </label>
          {question.description && (
            <p className="text-sm text-gray-600 mt-1">{question.description}</p>
          )}
          {question.esrs_paragraph && (
            <p className="text-xs text-gray-500 mt-1">
              Odkaz: {question.disclosure_requirement || question.code} - odstavec {question.esrs_paragraph}
            </p>
          )}
        </div>
      </div>

      {/* Input */}
      {renderInput()}

      {/* Validation Error */}
      {hasError && (
        <div className="flex items-start gap-2 text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">
          <span className="font-medium">⚠️</span>
          <span>{validationError}</span>
        </div>
      )}

      {/* Notes field (optional) */}
      {value && (
        <div>
          <label className="text-xs text-gray-600 mb-1 block">
            Poznámky (voliteľné)
          </label>
          <textarea
            value={value.notes || ''}
            onChange={(e) => onChange({ notes: e.target.value })}
            disabled={disabled}
            className="w-full min-h-[60px] px-3 py-2 text-sm border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-50"
            placeholder="Doplňujúce informácie..."
          />
        </div>
      )}
    </div>
  );
}
