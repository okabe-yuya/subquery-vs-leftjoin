CONTAINER_ID=$(docker run --env POSTGRES_PASSWORD=mysecretpassword --detach postgres:latest) &&
  until docker exec "${CONTAINER_ID}" pg_isready ; do sleep 1 ; done &&
  docker exec --interactive --tty "${CONTAINER_ID}" psql --username postgres &&
  docker rm --force --volumes "${CONTAINER_ID}" > /dev/null
