package utils

import io.gatling.app.Gatling
import io.gatling.core.config.GatlingPropertiesBuilder
import org.clapper.classutil.ClassFinder
import scala.io.Source.fromFile

object GatlingDebugger {
  private val scalaSourcePath = "./simulations"
  private val scalaBinPath = "./out/production/classes"
  private val simulationsClassPathRegex = "^.+Simulation$"

  private val runCurrentSimulationFlag = "--current-simulation"
  private val currentSimulationFile = ".currentIntelliJFile"

  def main(args: Array[String]) {
    println(Console.CYAN + "Gatling debugger started" + Console.WHITE)

    try {
      if (args.contains(runCurrentSimulationFlag)) {
        runCurrentSimulation()
      } else {
        runAllSimulations()
      }

      println(Console.CYAN + "Gatling debugger finished" + Console.WHITE)
    } catch {
      case e: Exception => {
        println(Console.RED + "Gatling debugger finished with errors" + Console.WHITE)

        throw e
      }
    }
  }

  //noinspection SourceNotClosed
  private def runCurrentSimulation(): Unit = {
    val currentSimulation = fromFile(currentSimulationFile).mkString

    runGatlingSimulation(currentSimulation)
  }

  private def runAllSimulations(): Unit = {
    ClassFinder()
        .getClasses
        .filter(!_.isAbstract)
        .filter(_.name.matches(simulationsClassPathRegex))
        .map(_.name)
        .foreach(runGatlingSimulation)
  }

  private def runGatlingSimulation(simulationClassPath: String): Unit = {
    val gatlingProperties = new GatlingPropertiesBuilder

    gatlingProperties.simulationsDirectory(scalaSourcePath)
    gatlingProperties.binariesDirectory(scalaBinPath)
    gatlingProperties.simulationClass(simulationClassPath)

    println(Console.YELLOW + s"Running gatling simulation '$simulationClassPath'..." + Console.WHITE)

    Gatling.fromMap(gatlingProperties.build)

    println(Console.CYAN + s"Gatling simulation '$simulationClassPath' finished" + Console.WHITE)
  }
}
