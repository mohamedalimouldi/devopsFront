### STAGE 1: BUILD ###
# Use an appropriate Node.js version
FROM node:14 AS build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the Angular app for production
RUN npm run build --prod

### STAGE 2: RUN ###
# Use an Nginx image
FROM nginx:latest

# Remove the default Nginx configuration
RUN rm -rf /etc/nginx/conf.d

# Copy the Nginx configuration file for your app
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built Angular app from the build stage to the Nginx server's HTML directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose the port
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
