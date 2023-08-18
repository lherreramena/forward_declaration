#!/bin/bash

set -e

# -- Defaults

ROOT_PATH=$(dirname "$(readlink -f "$BASH_SOURCE")")
BUILD_DIR=$ROOT_PATH/build
mkdir -p $BUILD_DIR

echo -- ROOT_PATH: $ROOT_PATH

#exit 0

#SOURCE_DIR=$(dirname $PWD)
BUILD_TYPE=Debug


POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--debug)
      BUILD_TYPE=Debug
      shift # past argument
      ;;
    -r|--release)
      BUILD_TYPE=Release
      shift # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

echo -- BUILD_TYPE: ${BUILD_TYPE}

echo -e "Running CMake..."

cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
	-DUTF_SHARED=1 \
  -B $BUILD_DIR \
	$ROOT_PATH

pushd $BUILD_DIR
echo -e "Running make..."
set -x
make -j$(nproc)
set +x
popd
