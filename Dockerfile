FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# --- BUILD-TIME SECRET USAGE ---
# The secret is mounted only for the duration of this RUN step, at
# /run/secrets/build_api_key. It is NEVER written to an image layer,
# NEVER shows up in `docker history`, and is not present in the final image.
# Use this pattern for things like a private npm registry token, a CMS
# API key needed for static generation, a Sentry auth token, etc.
RUN --mount=type=secret,id=build_api_key \
    export BUILD_API_KEY="$(cat /run/secrets/build_api_key)" && \
    npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV APP_ENV=production

# "standalone" output (see next.config.js) keeps the runtime image small
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

EXPOSE 3000
CMD ["node", "server.js"]

