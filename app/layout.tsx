export const metadata = {
  title: "ESRS SME Platform",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="sk" suppressHydrationWarning>
      <body suppressHydrationWarning style={{ fontFamily: "system-ui, sans-serif", padding: 16 }}>
        {children}
      </body>
    </html>
  );
}
