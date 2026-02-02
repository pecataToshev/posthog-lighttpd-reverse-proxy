# PostHog Lighttpd Reverse Proxy

This is a **Lighttpd** implementation of the PostHog Reverse Proxy, based on the [Nginx version](https://github.com/PostHog/posthog-nginx-reverse-proxy).

Because Lighttpd does not natively support proxying to HTTPS backends (which PostHog Cloud requires), this image uses **Stunnel** alongside Lighttpd to handle the secure connection.

## Usage

Build the image with the same arguments as the Nginx version:

```bash
docker build \
  --build-arg SERVER_NAME=my-proxy.com \
  --build-arg POSTHOG_CLOUD_REGION=us \
  --build-arg PORT=8080 \
  -t posthog-lighttpd-proxy .
```

Run the container:

```bash
docker run -p 8080:8080 posthog-lighttpd-proxy
```

## How it works

1.  **Lighttpd** listens on the configured port.
2.  It forwards requests to local `stunnel` ports.
3.  **Stunnel** wraps the traffic in SSL and forwards it to PostHog Cloud (`us.i.posthog.com` or `eu.i.posthog.com`).
4.  Headers are rewritten to match what PostHog expects (Host header, CORS).
