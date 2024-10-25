# Use the official Nginx image from Docker Hub
FROM nginx:alpine

# Copy survey.html and logo to the Nginx html folder
COPY Survey.html /usr/share/nginx/html/
COPY logo.jpg /usr/share/nginx/html/
COPY style4.css /usr/share/nginx/html/

# Expose port 80 for the web server
EXPOSE 80
