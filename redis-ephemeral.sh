podman run --rm --network=host --name redis -p 6379:6379 -v ./redis:/usr/local/etc/redis:z docker.io/library/redis:latest /usr/local/etc/redis/redis.conf
