# Stage 1: Build dependencies
FROM node:18-slim as builder

WORKDIR /app
COPY package*.json ./
RUN npm install --production

COPY . .

# Stage 2: Use Distroless base
FROM gcr.io/distroless/nodejs18

WORKDIR /app
COPY --from=builder /app /app

CMD ["server.js"]
