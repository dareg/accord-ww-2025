#!/bin/bash

set -x

FC=gfortran
FCFLAGS="-Wall -Wextra -g -O3"

rm mod_constants.mod yomtrc.mod

$FC $FCFLAGS mod_constants.F90 yomtrc.F90 main.F90 init_ttrc.F90 compute.F90 clean_data.F90
