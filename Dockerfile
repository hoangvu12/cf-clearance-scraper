FROM node:20-slim

ENV NODE_ENV production

# Set up the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install Node.js dependencies
RUN npm install
RUN npm install -g pm2

# Install necessary dependencies for running Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    apt-transport-https \
    xvfb \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O chromium-linux-arm64.zip 'https://playwright.azureedge.net/builds/chromium/1088/chromium-linux-arm64.zip' && \
  unzip chromium-linux-arm64.zip && \
  rm -f ./chromium-linux-arm64.zip

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV CHROME_PATH=/chrome-linux/chrome
ENV PUPPETEER_EXECUTABLE_PATH=/chrome-linux/chrome

# Copy the rest of the application code
COPY . .

# Expose the port your app runs on
EXPOSE 3000

# Command to run the application
CMD ["pm2-runtime", "index.js"]
