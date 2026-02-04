'use client';

import { VersionedQuestion, VersionedAnswer, DataType } from '@/types/esrs';
import { useState } from 'react';

interface DynamicQuestionInputProps {
  question: VersionedQuestion;
  value?: VersionedAnswer;
  onChange: (value: Partial<VersionedAnswer>) => void;
  disabled?: boolean;
}

export default function DynamicQuestionInput({
  question,
  value,
  onChange,
  disabled = false,
}: DynamicQuestionInputProps) {
  const dataType = question.data_type || 'narrative';

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

  // Render different input based on data type
  const renderInput = () => {
    switch (dataType) {
      case 'narrative':
        return (
          <textarea
            value={currentValue as string}
            onChange={(e) => handleChange(e.target.value)}
            disabled={disabled}
            className="w-full min-h-[120px] px-4 py-3 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500"
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
            className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500"
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
              className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500"
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
              className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500"
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
              className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500"
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
            className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500"
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
            className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-50 disabled:text-gray-500"
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
                Povinné
              </span>
            )}
            {question.is_voluntary && (
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
