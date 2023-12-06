

source $FLUTTER_WORKSPACE_DIRECTORY/tools/env.env

startEmulator

set -e
(cd $FLUTTER_FRONTEND_WORKSPACE_DIRECTORY && flutter test integration_test/tests --verbose --dart-define=BASE_URL=$SERVER_BASE_URL --dart-define=FIREBASE_ENABLED=false)
