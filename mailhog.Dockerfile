# Dockerfile.mailhog
FROM mailhog/mailhog:latest

# Optional tools for debugging or bash
USER root
RUN apk add --no-cache bash curl

CMD ["MailHog"]
