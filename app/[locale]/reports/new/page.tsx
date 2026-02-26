'use client';

import { useSearchParams, useParams } from 'next/navigation';
import Link from 'next/link';
import { useState } from 'react';
import { createVsmeReportAction } from '@/app/actions/reports';

export default function CreateVSMEReportPage() {
  const searchParams = useSearchParams();
  const params = useParams();
  
  const companyId = searchParams.get('companyId');
  const locale = params.locale as string;

  const [step, setStep] = useState(1);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Step 1 fields
  const [reportingYear, setReportingYear] = useState(new Date().getFullYear().toString());
  const [purpose, setPurpose] = useState('');

  // Step 2 fields
  const [employees, setEmployees] = useState('');
  const [turnover, setTurnover] = useState('');
  const [assets, setAssets] = useState('');

  // Validation helpers
  const isStep1Valid = reportingYear && purpose;
  const isStep2Valid = employees && turnover && assets;

  const validateEmployees = (val: string) => {
    if (!val) return true; // Allow empty initially
    const num = parseInt(val, 10);
    return !isNaN(num) && num >= 0;
  };

  const validateNumeric = (val: string) => {
    if (!val) return true; // Allow empty initially
    const num = parseFloat(val);
    return !isNaN(num) && num >= 0;
  };

  const handleEmployeesChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setEmployees(e.target.value);
    setError(null);
  };

  const handleTurnoverChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setTurnover(e.target.value);
    setError(null);
  };

  const handleAssetsChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setAssets(e.target.value);
    setError(null);
  };

  const handleNext = () => {
    setError(null);
    if (!isStep1Valid) {
      setError('Please fill in all required fields.');
      return;
    }
    setStep(2);
  };

  const handleBack = () => {
    setError(null);
    setStep(1);
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError(null);

    if (!isStep2Valid) {
      setError('Please fill in all required fields.');
      return;
    }

    if (!validateEmployees(employees)) {
      setError('Employees must be a non-negative integer.');
      return;
    }

    if (!validateNumeric(turnover)) {
      setError('Turnover must be a non-negative number.');
      return;
    }

    if (!validateNumeric(assets)) {
      setError('Assets must be a non-negative number.');
      return;
    }

    setLoading(true);

    try {
      const formData = new FormData();
      formData.append('companyId', companyId || '');
      formData.append('locale', locale);
      formData.append('reportingYear', reportingYear);
      formData.append('purpose', purpose);
      formData.append('employees', employees);
      formData.append('turnover', turnover);
      formData.append('assets', assets);

      await createVsmeReportAction(formData);
    } catch (err: any) {
      setError(err.message || 'Failed to create report');
      setLoading(false);
    }
  };

  if (!companyId) {
    return (
      <div className="min-h-screen bg-gray-50 p-8">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-3xl font-bold text-gray-900 mb-6">Create VSME Report</h1>
          <div className="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
            <p className="text-red-800">Error: Missing company ID. Please create a company first.</p>
          </div>
          <Link 
            href={`/${locale}/profile`} 
            className="inline-block px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700 transition-colors"
          >
            Back to Profile
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-2xl mx-auto">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Create VSME Report</h1>
        <p className="text-gray-600 mb-6">Step {step} of 2</p>

        {error && (
          <div className="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
            <p className="text-red-800">{error}</p>
          </div>
        )}

        <div className="bg-white rounded-lg shadow p-6">
          {step === 1 ? (
            <div>
              <h2 className="text-lg font-semibold text-gray-900 mb-4">Report Details</h2>

              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Reporting Year <span className="text-red-500">*</span>
                </label>
                <select
                  value={reportingYear}
                  onChange={(e) => {
                    setReportingYear(e.target.value);
                    setError(null);
                  }}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Select year</option>
                  {Array.from({ length: 5 }, (_, i) => {
                    const year = new Date().getFullYear() - i;
                    return (
                      <option key={year} value={year}>
                        {year}
                      </option>
                    );
                  })}
                </select>
              </div>

              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Purpose <span className="text-red-500">*</span>
                </label>
                <select
                  value={purpose}
                  onChange={(e) => {
                    setPurpose(e.target.value);
                    setError(null);
                  }}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Select purpose</option>
                  <option value="financing">Financing</option>
                  <option value="supply_chain">Supply Chain</option>
                  <option value="investor">Investor Due Diligence</option>
                  <option value="voluntary">Voluntary</option>
                </select>
              </div>

              <div className="flex gap-4">
                <button
                  onClick={handleNext}
                  disabled={!isStep1Valid}
                  className="flex-1 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
                >
                  Next
                </button>
                <Link 
                  href={`/${locale}/profile`} 
                  className="flex-1 px-6 py-2 bg-gray-300 text-gray-800 rounded-lg hover:bg-gray-400 transition-colors text-center"
                >
                  Cancel
                </Link>
              </div>
            </div>
          ) : (
            <form onSubmit={handleSubmit}>
              <h2 className="text-lg font-semibold text-gray-900 mb-4">Company Metrics</h2>

              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Number of Employees <span className="text-red-500">*</span>
                </label>
                <input
                  type="number"
                  value={employees}
                  onChange={handleEmployeesChange}
                  min="0"
                  placeholder="e.g., 250"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                />
                {employees && !validateEmployees(employees) && (
                  <p className="text-red-600 text-sm mt-1">Must be a non-negative integer</p>
                )}
              </div>

              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Turnover (EUR) <span className="text-red-500">*</span>
                </label>
                <input
                  type="number"
                  value={turnover}
                  onChange={handleTurnoverChange}
                  min="0"
                  step="0.01"
                  placeholder="e.g., 50000000"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                />
                {turnover && !validateNumeric(turnover) && (
                  <p className="text-red-600 text-sm mt-1">Must be a non-negative number</p>
                )}
              </div>

              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Total Assets (EUR) <span className="text-red-500">*</span>
                </label>
                <input
                  type="number"
                  value={assets}
                  onChange={handleAssetsChange}
                  min="0"
                  step="0.01"
                  placeholder="e.g., 25000000"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                />
                {assets && !validateNumeric(assets) && (
                  <p className="text-red-600 text-sm mt-1">Must be a non-negative number</p>
                )}
              </div>

              <div className="flex gap-4">
                <button
                  type="submit"
                  disabled={!isStep2Valid || loading}
                  className="flex-1 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
                >
                  {loading ? 'Creating...' : 'Create Report'}
                </button>
                <button
                  type="button"
                  onClick={handleBack}
                  disabled={loading}
                  className="flex-1 px-6 py-2 bg-gray-300 text-gray-800 rounded-lg hover:bg-gray-400 disabled:cursor-not-allowed transition-colors"
                >
                  Back
                </button>
              </div>
            </form>
          )}
        </div>
      </div>
    </div>
  );
}
