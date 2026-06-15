# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Install only dependencies
RUN npm install

# Copy rest of the code
COPY . .

# ---------- Stage 2: Production ----------
FROM node:20-alpine

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app /app

# Remove dev dependencies
RUN npm prune --production

# Expose port
EXPOSE 5000

# Start app (NO nodemon in production)
CMD ["node", "server.js"]