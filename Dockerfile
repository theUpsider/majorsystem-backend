# Use the official Node.js image.
# Use a specific version of Node.js, here it's 18.
FROM node:18

# Install Python for dataset preparation
RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy package.json and package-lock.json.
COPY package*.json ./

# Install dependencies.
RUN npm install

# Copy Prisma schema first
COPY prisma ./prisma

# Copy .env file for environment variables
COPY .env ./

# Set DATABASE_URL for build-time operations (correct path)
ENV DATABASE_URL="file:./prisma/dev.db"

# Generate Prisma client
RUN npx prisma generate

# Copy dataset preparation files
COPY prepare_dataset.py ./
COPY substitution_dict.json ./
COPY datasets ./datasets

# Prepare the dataset
RUN python3 prepare_dataset.py datasets/wordlist-german.txt major_system_data.csv substitution_dict.json

# Copy the rest of the application code.
COPY . .

# Ensure proper permissions and create database
RUN mkdir -p /usr/src/app/prisma && \
    chown -R node:node /usr/src/app/prisma && \
    npx prisma db push && \
    npm run populate

# Set the correct runtime DATABASE_URL
ENV DATABASE_URL="file:./prisma/dev.db"

# Change to node user for security
USER node

# Expose the port the app runs on.
EXPOSE 5000

# Run the development script.
CMD ["npm", "run", "dev"]
