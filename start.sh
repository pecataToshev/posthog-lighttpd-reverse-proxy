#!/bin/sh

# Fail on error
set -e

# Process Stunnel configuration
# We substitute the POSTHOG_CLOUD_REGION variable
envsubst '${POSTHOG_CLOUD_REGION}' < /etc/stunnel/stunnel.conf.template > /etc/stunnel/stunnel.conf

# Process Lighttpd configuration
# We substitute PORT and POSTHOG_CLOUD_REGION
envsubst '${PORT},${POSTHOG_CLOUD_REGION}' < /etc/lighttpd/lighttpd.conf.template > /etc/lighttpd/lighttpd.conf

echo "Starting Stunnel..."
stunnel /etc/stunnel/stunnel.conf

echo "Starting Lighttpd..."
# Run lighttpd in foreground
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
