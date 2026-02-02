FROM alpine:latest

# Install Lighttpd and modules, Stunnel for SSL tunneling, and Gettext for envsubst
RUN apk add --no-cache \
    lighttpd \
    stunnel \
    gettext \
    ca-certificates

# Copy templates and scripts
COPY lighttpd.conf.template /etc/lighttpd/lighttpd.conf.template
COPY stunnel.conf.template /etc/stunnel/stunnel.conf.template
COPY start.sh /start.sh

RUN chmod +x /start.sh

# Create the health check file
RUN mkdir -p /var/www/localhost/htdocs && \
    echo "OK" > /var/www/localhost/htdocs/health.txt

# Default arguments (matching the Nginx repo)
ARG SERVER_NAME=localhost
ARG PORT=8080
ARG POSTHOG_CLOUD_REGION=us

# Set environment variables for the runtime script
ENV SERVER_NAME=$SERVER_NAME
ENV PORT=$PORT
ENV POSTHOG_CLOUD_REGION=$POSTHOG_CLOUD_REGION

# Expose the port
EXPOSE $PORT

CMD ["/start.sh"]
