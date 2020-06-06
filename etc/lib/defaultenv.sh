if ! [ -n "$GRAMCLI" ]; then
  echo "Run scripts using 'gram \$command'"; gram help
  exit 1
fi

export GRAM_IP=localhost
export TON_ENGINE_PORT=6302
export TON_OUTGOING=3278
export LITESERVER_PORT=6304
export JSON_EXPLORER_PORT=8082
export CONSOLE_PORT=6303
export GRAM_API_PORT=8084
export DOCS_PORT=8090
export WEB_EXPLORER_PORT=8083
export NAV_PORT=8088
export TON_LOGLEVEL=3
export DOTENV_CONFIG_PATH=$GRAMCORE/.env
export FIFTPATH=$GRAMCORE/ton/crypto/fift/lib:$GRAMCORE/ton/crypto/smartcont
export LS_PUB=$GRAMCORE/profile/keys/liteserver.pub
export FIFTLIB=$GRAMCORE/ton/crypto/smartcont
export PROFILE=$GRAMCORE/profile
export TON_SMARTCONT=$GRAMCORE/ton/crypto/smartcont
export VIZ_PORT=8089
export NODE_OPTIONS="--max_old_space_size=4096"
export NODE_ENV=development
# these are going to be switched up by env.sh
export RUNVALIDATOR=1
export RUNNAVIGATOR=1
export RUNAPI=1
export NODETYPE=regtest
export DEPLOYTYPE=metal
export GLOBALCONFIG=
export IMAGEURI="registry.gitlab.com/gram-net/gram:1.0.0"
export JSON_EXPLORER_URI="http://localhost"
export GRAM_API_URI="http://localhost"