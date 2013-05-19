#!/bin/bash

# Stop script if any command fails.
set -e

DEVISE_SCRIPT="structure.scm"
BASE_NAME="quad"
DESSIS_COMMANDS="settings_des.cmd"

devise -e -l $DEVISE_SCRIPT > "simulate.log"
mesh -P $BASE_NAME >> "simulate.log"
dessis $DESSIS_COMMANDS >> "simulate.log"

echo "Done!"
echo "Run techplot_sie ${BASE_NAME}_des.dat ${BASE_NAME}_msh.grd to view."
