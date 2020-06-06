if ! [ $GRAMCLI ]; then
  echo "Run scripts using 'gram \$command'"
  exit 1
fi
art
which git
nvm use
yarn cache clean
yarn

if ! [ -n "$ARG1" ] || [ "$ARG1" == "esmodules" ]; then 
  cd $GRAMCORE/wasm
  yarn
  yarn build
  cd $GRAMCORE/api
  yarn
  yarn build
fi
if ! [ -n "$ARG1" ] || [ "$ARG1" == "navigator" ]; then
  cd $GRAMCORE/navigator
  mkdir -p public/tapplets
  ln -s ../.env .env || : 
  rm -rf node_modules/ src-cordova/node_modules src-cordova/platforms src-cordova/plugins src-cordova/www || : 
  rm -f **/*.apk || : 
  rm -f public/cordova.js || : 
  if ! [ -n "$LINUX" ]; then npm install -g deploy; fi
  npm install -g cordova
  yarn
  yarn sync-config-xml 
  yarn wasm
  cd src-cordova
  mkdir -p www
  yarn
  cordova platform add android
  cordova platform add ios
  cordova platform add browser
  cordova prepare
  echo "@implementation NSURLRequest(DataController) + (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {    return YES;}@end" >> ./platforms/ios/Tigerbee/Classes/AppDelegate.m
  cd ..
  if [ "$ARG2" != "dev" ]; then
    NODE_ENV=production NODE_OPTIONS=--max_old_space_size=4096 yarn build-web
  fi
fi