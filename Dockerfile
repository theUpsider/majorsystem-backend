# Use the official Node.js image.
# Use a specific version of Node.js, here it's 18.
FROM node:18

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy package.json and package-lock.json.
COPY package*.json ./

# Install dependencies.
RUN npm install

# Copy Prisma schema first
COPY prisma ./prisma

# Generate Prisma client
RUN npx prisma generate

# Copy the rest of the application code.
COPY . .

# Expose the port the app runs on.
EXPOSE 5000

# Run the development script.
CMD ["npm", "run", "dev"]
