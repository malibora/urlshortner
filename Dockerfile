# Use the official Node.js image as the base
FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install application dependencies
RUN npm install --production

# Copy the rest of the application code to the working directory
COPY . .

RUN mkdir --parents /.mysql && \
wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" \
    --output-document /.mysql/root.crt && \
chmod 0600 /.mysql/root.crt
# Expose the port your application listens on
EXPOSE 80

# Run the Node.js application
CMD ["node", "server.js"]