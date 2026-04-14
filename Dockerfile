FROM node:22-alpine

# Install dependencies and required packages
RUN apk add --no-cache chromium nss freetype harfbuzz ca-certificates ttf-freefont wget git
# Fix npm install issue on alpine node 22
RUN npm cache clean --force && npm install -g npm@10.9.2

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Install Playwright browsers (skip deps since we installed chromium via apk)
RUN npx playwright install chromium

# Copy application code
COPY . .

# Create required directories
RUN mkdir -p data output reports

# Set environment variables for Playwright
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Expose any ports if needed (for future dashboard)
EXPOSE 3000

# Run doctor check on startup
CMD ["node", "doctor.mjs"]
