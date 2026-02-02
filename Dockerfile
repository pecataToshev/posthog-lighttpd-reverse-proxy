FROM alpine:latest AS builder

# Install gettext for envsubst
RUN apk add --no-cache gettext

# Copy templates
COPY lighttpd.conf.template /tmp/lighttpd.conf.template
COPY stunnel.conf.template /tmp/stunnel.conf.template

# Build arguments
ARG SERVER_NAME=localhost
ARG PORT=8080
ARG POSTHOG_CLOUD_REGION=us

# Generate configurations
# We export the ARGs as ENV vars so envsubst can see them
RUN export SERVER_NAME=$SERVER_NAME \
    && export PORT=$PORT \
    && export POSTHOG_CLOUD_REGION=$POSTHOG_CLOUD_REGION \
    && envsubst '${PORT},${SERVER_NAME},${POSTHOG_CLOUD_REGION}' < /tmp/lighttpd.conf.template > /tmp/lighttpd.conf \
    && envsubst '${POSTHOG_CLOUD_REGION}' < /tmp/stunnel.conf.template > /tmp/stunnel.conf

# -----------------------------------------------------------------------------
# Final Stage
# -----------------------------------------------------------------------------
FROM alpine:latest

# Install runtime dependencies only
RUN apk add --no-cache \
    lighttpd \
    lighttpd-mod-proxy \
    lighttpd-mod-setenv \
    lighttpd-mod-rewrite \
    stunnel \
    ca-certificates

# Copy generated configurations from builder
COPY --from=builder /tmp/lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY --from=builder /tmp/stunnel.conf /etc/stunnel/stunnel.conf
COPY start.sh /start.sh

# Prepare directories
RUN chmod +x /start.sh && \
    mkdir -p /var/www/localhost/htdocs && \
    echo "OK" > /var/www/localhost/htdocs/health.txt

# We expose the port that was baked into the config
# Note: Docker EXPOSE is documentation; the actual listening port depends on the config
EXPOSE 8080

CMD ["/start.sh"]
