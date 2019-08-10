#! /usr/bin/env bash
set -e

scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "${scriptPath}/scripts/common.sh" "$@"

simulationsPath="${scriptPath}/simulations"
simulation="$1"

function runSimulation() {
  banner "Running Gatling simulation: ${simulation}"

  ${rootPath}/gatling-bundle/gatling-charts-highcharts-bundle-*/bin/gatling.sh \
      -rf "${resultsPath}" \
      -sf "${simulationsPath}" \
      -s "${simulation}"

  banner "Gatling simulation '${simulation}' completed successfully"
}

function parseArguments() {
  if [ "${simulation}" == "--current-simulation" ]; then
    simulation=$(< "${scriptPath}/.currentIntelliJFile")
  fi

  if [ -z "$simulation" ]; then
    errorAndExit "Usage: $0 simulationClassPath | e.g. $0 test.TestSimulation"
  fi
}

parseArguments

if [[ "$@" != *"--no-refresh"* ]]; then
  refreshGatlingEnvironment
fi

runSimulation
