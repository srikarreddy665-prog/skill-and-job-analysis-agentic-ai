# Multi-stage production build for Agentic AI Skill & Job Analysis Platform
FROM node:20-alpine AS builder

WORKDIR /app

# Copy root and workspace package manifests
COPY package.json ./
COPY backend/package*.json ./backend/
COPY frontend/package*.json ./frontend/

# Install dependencies
RUN npm --prefix backend install
RUN npm --prefix frontend install

# Copy source trees
COPY backend ./backend
COPY frontend ./frontend

# Build optimized production frontend
RUN npm --prefix frontend run build

# Production runtime stage
FROM node:20-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production
ENV PORT=5000
ENV HOST=0.0.0.0

COPY package.json ./
COPY backend ./backend
COPY --from=builder /app/backend/node_modules ./backend/node_modules
COPY --from=builder /app/frontend/dist ./frontend/dist

EXPOSE 5000

CMD ["node", "backend/src/server.js"]
