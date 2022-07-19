#!/bin/bash

runIntegrationTests() 
{
    search_dir="$FLUTTER_FRONTEND_WORKSPACE_DIRECTORY/integration_test"
    for test in $(find $search_dir -type f -name "*_test.dart")
    do
        flutter drive --driver=test_driver/integration_test.dart --target=$test -d "emulator-5554" --dart-define=BASE_URL=http://10.0.2.2:3000/api
    done
}

runIntegrationTests