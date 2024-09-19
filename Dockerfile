# Build Stage
FROM node:21-alpine AS build

# Create a working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Build the application
RUN npm run build

# Production Stage
FROM node:21-alpine

# Set the working directory
WORKDIR /app

# Copy only the production dependencies and built application from the build stage
COPY --from=build /app/package*.json ./
RUN npm install --production

COPY --from=build /app/dist ./dist

# Expose the port your application will run on
EXPOSE 3000

# Create a non-root user to run the application
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Set environment variables
ENV NODE_ENV=production

# Add a health check (optional but recommended)
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s \
  CMD curl -f http://localhost:3000/health || exit 1

# Start the application
CMD [ "npm", "start" ]
