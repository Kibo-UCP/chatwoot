docker build -f docker/dockerfiles/build-js.Dockerfile . -t chatwoot-build-js
docker run -it --rm -v "$(pwd):/app"  chatwoot-build-js 

# you might want to interactively run pnpm
# docker run -it --rm -v "$(pwd):/app"  chatwoot-build-js  --entrypoint sh