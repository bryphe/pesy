#!/bin/bash

set -e
set -u

BOLD=`tput bold`  || BOLD=''   # Select bold mode
BLACK=`tput setaf 0` || BLACK=''
RED=`tput setaf 1` || RED=''
GREEN=`tput setaf 2` || GREEN=''
YELLOW=`tput setaf 3` || YELLOW=''
RESET=`tput sgr0` || RESET=''

MODE="update"
[[ $SHELL =~ "noprofile" ]] && MODE="build"


LAST_EXE_NAME=""
NOTIFIED_USER="false"
BUILD_STALE_PROBLEM="false"

DEFAULT_MAIN_MODULE_NAME="Index"

function notifyUser() {
  if [ "${NOTIFIED_USER}" == "false" ]; then
    echo ""
    if [ "${MODE}" == "build" ]; then
      printf "  %sAlmost there!%s %sWe just need to prepare a couple of files:%s\\n\\n" "${YELLOW}${BOLD}" "${RESET}" "${BOLD}" "${RESET}"
    else
      printf "  %sPreparing for build:%s\\n\\n" "${YELLOW}${BOLD}" "${RESET}"
    fi
    NOTIFIED_USER="true"
  else
    # do nothing
    true
  fi
}


function printDirectory() {
  DIR=$1
  NAME=$2
  NAMESPACE=$3
  REQUIRE=$4
  IS_LAST=$5
  printf "│\\n"
  PREFIX=""
  if [[ "$IS_LAST" == "last" ]]; then
    printf "└─%s/\\n" "$DIR"
    PREFIX="    "
  else
    printf "├─%s/\\n" "$DIR"
    PREFIX="│   "
  fi
  printf "%s%s\\n" "$PREFIX" "$NAME"
  printf "%s%s\\n" "$PREFIX" "$NAMESPACE"
  if [ -z "$REQUIRE" ]; then
    true
  else
    if [ "$REQUIRE" != " " ]; then
      printf   "%s%s\\n" "$PREFIX" "$REQUIRE"
    fi
  fi
}
