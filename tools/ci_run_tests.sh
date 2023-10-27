#!/bin/bash

#source $FLUTTER_WORKSPACE_DIRECTORY/tools/env.env

docker run \
    --network="host" \
    -v $(pwd):/workspaces/flutter_skeleton \
    --privileged \
    --env FLUTTER_WORKSPACE_DIRECTORY=/workspaces/flutter_skeleton \
    nicolas71640/docked_flutter \
    /workspaces/flutter_skeleton/tools/docker_run_tests.sh
