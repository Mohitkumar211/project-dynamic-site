export async function getServerSideProps() {
  // Runs on every request -> makes this a genuinely dynamic page,
  // not a static export.
  return {
    props: {
      renderedAt: new Date().toISOString(),
      env: process.env.APP_ENV || "development"
    }
  };
}

export default function Home({ renderedAt, env }) {
  return (
    <main style={{ fontFamily: "sans-serif", padding: "2rem" }}>
      <h1>Dynamic Site</h1>
      <p>Environment: {env}</p>
      <p>Rendered at: {renderedAt}</p>
    </main>
  );
}
