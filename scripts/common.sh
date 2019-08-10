#! /usr/bin/env bash
set -e

# polyfill for realpath command using python
command -v realpath &> /dev/null || realpath() {
  python -c "import os; print os.path.abspath('$1')"
}

scriptsPath=$(realpath "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")

rootPath=$(realpath "${scriptsPath}/..")
resultsPath="${rootPath}/results"
simulationsPath="${rootPath}/simulations"

function dateTimeNow() {
  printf "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")]"
}

function log() {
  printf "$(dateTimeNow) $1: $2"
}

function logInfo() {
  echo "$(log "INFO" "$1")"
}

function logError() {
  >&2 echo "$(log "ERROR" "$1")"
}

function banner() {
  echo
  echo ">> $(log "INFO" "$1") <<"
  echo
}

function errorAndExit() {
  logError "$1"
  exit 1
}

function silentPushd() {
  pushd "$1" > /dev/null
}

function silentPopd() {
  popd > /dev/null
}

function refreshGatlingEnvironment() {
  banner "Refreshing Gatling Environment"

  silentPushd "${rootPath}"

  ./gradlew

  silentPopd
}

function cleanResults() {
  logInfo "Cleaning old results"

  rm -rf "${resultsPath}"
}

# run optional flag functions if present
if [[ "$@" == *"--clean-results"* ]]; then
  cleanResults
fi
