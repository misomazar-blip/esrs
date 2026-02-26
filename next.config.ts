import type { NextConfig } from "next";
import createNextIntlPlugin from 'next-intl/plugin';

const withNextIntl = createNextIntlPlugin('./i18n.config.ts');

const nextConfig: NextConfig = {
  // Turbopack disabled for better App Router params compatibility
};

export default withNextIntl(nextConfig);
