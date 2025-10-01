FROM alpine:3.20
RUN apk add --no-cache bash curl jq coreutils procps iproute2 sysstat
WORKDIR /app
COPY scripts/ /app/scripts/
COPY config/.env.example /app/config/.env
ENV WEBHOOK_URL=""
CMD ["bash","-c","source /app/config/.env && /app/scripts/health_summary.sh && sleep 300"]
 
