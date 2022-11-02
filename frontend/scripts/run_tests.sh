#!/bin/bash
search_dir=$1

for testPath in "$search_dir"/*
do
  if [[ "$testPath" == *"_test.dart" ]]; then
    printf "\n\n***************************************************************\n"
    printf "RUNNING : $testPath\n"
    printf "***************************************************************\n\n"

    flutter drive \
      --driver=test_driver/integration_test.dart \
      --target=$testPath \
      --verbose \
      "${@:2}"
  fi
done
