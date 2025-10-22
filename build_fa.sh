#!/bin/bash

MYROOT=$PWD
INSTALL_DIR=$PWD/hands_on_install

module load ecbuild
module load nvidia/24.5
export FC=nvfortran
export CC=nvc

#FIAT
if [ ! -d fiat ]; then
  git clone https://github.com/ecmwf-ifs/fiat
fi    
cd fiat || exit 1
mkdir build
cd build || exit 1
cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DBUILD_SHARED_LIBS=ON
make -j 16
make install
cd $MYROOT || exit 1

#FIELD API
if [ ! -d field_api ]; then
  git clone https://github.com/ecmwf-ifs/field_api
fi
cd field_api || exit 1

mkdir build
cd build || exit 1
export fiat_ROOT=$INSTALL_DIR

cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DBUILD_SHARED_LIBS=ON
make -j 16
make install
cd $MYROOT || exit 1
