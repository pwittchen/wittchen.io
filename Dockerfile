FROM hugomods/hugo:exts

RUN apk add --no-cache nginx

WORKDIR /src
COPY . .

# Build Hugo site at build time
ARG BASE_URL=http://localhost:8080/
RUN echo "Building Hugo site with BASE_URL: $BASE_URL" && \
    hugo --minify --baseURL "$BASE_URL"

# Copy built site to nginx directory
RUN mkdir -p /usr/share/nginx/html && \
    cp -r /src/public/* /usr/share/nginx/html/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
