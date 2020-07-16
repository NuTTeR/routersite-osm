FROM overv/openstreetmap-tile-server:1.3

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.6.0/wait /wait
RUN chmod +x /wait

COPY entrypoint.sh /