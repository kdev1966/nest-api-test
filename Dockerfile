# Build Stage
FROM node:21-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production Stage
FROM node:21-alpine

WORKDIR /app

# Only copy necessary files for production
COPY --from=build /app/package*.json ./
RUN npm install --production
COPY --from=build /app/dist ./dist

EXPOSE 3000

CMD [ "npm", "start" ]
