# PostHog Reverse Proxy (Lighttpd Version)

A reverse proxy allows you to send events to PostHog Cloud using your own domain. This means that events are less likely to be intercepted by tracking blockers. You'll be able to capture more usage data without having to self-host PostHog.

Setting up a reverse proxy means setting up a service to redirect requests from a subdomain you choose (like `e.yourdomain.com`) to PostHog. It is best practice to use a subdomain that does not include words like `posthog`, `analytics`, `tracking`, or other similar terms. You then use this subdomain as your `api_host` in the initialization of PostHog instead of `us.i.posthog.com` or `eu.i.posthog.com`.

`posthog.init('phc_YOUR_TOKEN', { api_host: 'https://$SERVER_NAME' })`

This repository provides a **Lighttpd** implementation of the proxy.

## Getting started

Build the image:

```bash
docker build \
  --build-arg SERVER_NAME=e.yourdomain.com \
  --build-arg POSTHOG_CLOUD_REGION=us \
  --build-arg PORT=8080 \
  -t posthog-proxy .
```

## Running

The service requires `SERVER_NAME` and `PORT` build arguments to be set during the build.

*   `SERVER_NAME` is the DNS address of this service.
*   `PORT` is the port that the server will listen to, with `80` being the recommended choice.

This setup does not inherently use TLS (for client connections), as it assumes it will run on platforms like Railway, which enforce TLS at their edge proxy.

The `Dockerfile` will populate the `lighttpd.conf` and `stunnel.conf` templates with the provided arguments.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Resources

*   [PostHog Documentation](https://posthog.com/docs/advanced/proxy)
