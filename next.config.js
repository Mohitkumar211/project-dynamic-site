/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  output: "standalone" // produces a minimal server bundle, ideal for Docker
};

module.exports = nextConfig;

