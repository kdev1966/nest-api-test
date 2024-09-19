# Build Stage
FROM node:21-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

# Install Nest CLI globally
RUN npm install -g @nestjs/cli

COPY . .
RUN npm run build

# Production Stage
FROM node:21-alpine

WORKDIR /app

COPY --from=build /app/package*.json ./
RUN npm install --production

# Install Nest CLI globally in the production image
RUN npm install -g @nestjs/cli

COPY --from=build /app/dist ./dist

EXPOSE 3000

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

ENV NODE_ENV=production

CMD [ "node", "dist/main.js" ]
