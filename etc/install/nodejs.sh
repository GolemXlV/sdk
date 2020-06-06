if ! [ -n "$GRAMCLI" ]; then
  echo "Run scripts using 'gram \$command'"; gram help
  exit 1
fi
art

if ! [ $(command -v nvm) ]; then
  ec "Installing NVM"
  # create user profile if none exists
  FILES=( "${HOME}/.bashrc" "${HOME}/.bash_profile" "${HOME}/.zshrc" "${HOME}/.profile" )
  PROFILEEXISTS=
  for f in "${FILES[@]}"
  do
    if [ -e $f ]; then 
      PROFILEEXISTS=1; 
    fi
  done
  if [ "$PROFILEEXISTS" == "" ]; then
    ec "NO SHELL PROFILE FOUND. Creating ~/.profile"
    touch ~/.profile; 
  fi
  curl https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash -
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || :  # This loads nvm

ec "installing GRAM nvm version (lts/erbium 12.x)"
nvm install

ec "installing/updating yarn/pm2 globally..."
npm install -g yarn pm2