#!/bin/bash


startEmulator

(cd $FLUTTER_FRONTEND_WORKSPACE_DIRECTORY && flutter test integration_test/tests --verbose --dart-define=BASE_URL=http://10.0.2.2:3000/api --dart-define=FIREBASE_ENABLED=false)
