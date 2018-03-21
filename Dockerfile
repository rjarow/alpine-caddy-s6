FROM rjarow/alpine64-s6
LABEL maintainer "Rich J github.com/rjarow" architecture="AMD64/x86_64"

# Get necessities
RUN apk --no-cache add bash less vim git gzip tar curl ca-certificates openssh-client libcap && \
    rm -rf /var/cache/apk/*

# Download Caddy and all middleware
RUN curl \
## This is every middleware plugin, but fails to download currently
#   "https://caddyserver.com/download/linux/amd64?plugins=dns%2Cdyndns%2Chook.service%2Chttp.authz%2Chttp.awses%2Chttp.awslambda%2Chttp.cache%2Chttp.cgi%2Chttp.cors%2Chttp.datadog%2Chttp.expires%2Chttp.filemanager%2Chttp.filter%2Chttp.forwardproxy%2Chttp.git%2Chttp.gopkg%2Chttp.grpc%2Chttp.hugo%2Chttp.ipfilter%2Chttp.jekyll%2Chttp.jwt%2Chttp.locale%2Chttp.login%2Chttp.mailout%2Chttp.minify%2Chttp.nobots%2Chttp.prometheus%2Chttp.proxyprotocol%2Chttp.ratelimit%2Chttp.realip%2Chttp.reauth%2Chttp.restic%2Chttp.upload%2Chttp.webdav%2Cnet%2Ctls.dns.azure%2Ctls.dns.cloudflare%2Ctls.dns.digitalocean%2Ctls.dns.dnsimple%2Ctls.dns.dnspod%2Ctls.dns.dyn%2Ctls.dns.exoscale%2Ctls.dns.gandi%2Ctls.dns.googlecloud%2Ctls.dns.linode%2Ctls.dns.namecheap%2Ctls.dns.ovh%2Ctls.dns.rackspace%2Ctls.dns.rfc2136%2Ctls.dns.route53%2Ctls.dns.vultr&license=personal" \

# This is the more simple version with git, hugo/jekyll and http headers
    "https://caddyserver.com/download/linux/amd64?plugins=hook.service,http.cors,http.expires,http.filemanager,http.filter,http.git,http.gopkg,http.hugo,http.jekyll,http.login,http.minify,http.upload&license=personal" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy



# Copy Files in for s6 and Caddyfile
COPY files/ /

# Set Env in case we need BASH
ENV TERM="xterm"

# Expose web ports
EXPOSE 80

# Allow /var/www/html to be mounted since we'll be putting our root for caddy in /var/www/html
VOLUME ["/var/www/html"]
VOLUME ["/caddy"]
