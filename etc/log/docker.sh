if ! [ -n "$GRAMCLI" ]; then
  echo "Run scripts using 'gram \$command'"; gram help
  exit 1
fi
ART=log
art

if [ "$DEPLOYTYPE" == "compose" ]; then
  PREFIX=gram
  SUFFIX=_1
  DOCKER=1
  docker logs ${PREFIX}_gram$SUFFIX 2>&1 | head -250
  docker logs -f ${PREFIX}_gram$SUFFIX 2>&1
elif [ "$DEPLOYTYPE" == "swarm" ]; then
  PREFIX=GRAM1
  SUFFIX=
  DOCKER=1
  runcmd docker service ps --no-trunc ${PREFIX}_gram$SUFFIX
  docker service logs --tail=50 ${PREFIX}_gram$SUFFIX 2>&1
else
  fail "Log docker" "Docker mode is off. run gram env to change to docker compose or swarm mode"
fi

