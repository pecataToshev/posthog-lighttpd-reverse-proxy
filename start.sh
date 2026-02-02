#!/bin/sh

# Fail on error
set -e

echo "Starting Stunnel..."
stunnel /etc/stunnel/stunnel.conf

echo "Starting Lighttpd..."
# Run lighttpd in foreground
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
