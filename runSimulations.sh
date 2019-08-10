#! /usr/bin/env bash
set -e

scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "${scriptPath}/scripts/common.sh" "$@"

runSimulationScript="${scriptPath}/runSimulation.sh"
simulationsCsv="$1"
simulations=()

function runSimulations() {
  banner "Running Gatling simulations: ${simulationsCsv}"

  refreshGatlingEnvironment

  for simulation in "${simulations[@]}"; do
    cleanSimulationName=$(printf "${simulation}" | awk -F "." "{print \$NF}")
    cleanSimulationName=${cleanSimulationName/Simulation/}

    "${runSimulationScript}" "${simulation}" --no-refresh 2>&1 | sed "s/^/[${cleanSimulationName}] /" &
  done

  wait

  banner "Gatling simulations have exited"
}

function discoverSimulations() {
  for simulation in ${simulationsPath}/**/*Simulation.scala; do
    simulationName=${simulation/.scala/}
    simulationName=${simulationName/${rootPath}\/simulations\//}
    simulationName=${simulationName//\//.}

    if [ -z "${simulationsCsv}" ]; then
      simulationsCsv="${simulationName}"
    else
      simulationsCsv="${simulationsCsv},${simulationName}"
    fi
  done
}

function parseArguments() {
  if [[ "$@" == *"--help"* ]]; then
    errorAndExit "Usage: $0 simulationClassPathsCsv | $0 test.TestSimulation,test.AnotherTestSimulation"
  fi

  if [ -z "${simulationsCsv}" ]; then
    discoverSimulations
  fi

  IFS=', ' read -r -a simulations <<< "${simulationsCsv}"
}

parseArguments
runSimulations
