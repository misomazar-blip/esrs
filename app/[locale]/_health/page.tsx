export default function HealthPage() {
  return (
    <div style={{ padding: "2rem", fontFamily: "monospace" }}>
      <h1>✅ Health Check OK</h1>
      <p>Locale routing is working correctly.</p>
      <p>Time: {new Date().toISOString()}</p>
    </div>
  );
}
