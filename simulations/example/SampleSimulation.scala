package example

import io.gatling.core.Predef._     // required for Gatling core structure DSL
import io.gatling.http.Predef._     // required for Gatling HTTP DSL

import scala.concurrent.duration._  // used for specifying duration unit, eg "5 second"

class SampleSimulation extends Simulation {
  // Here is the root for all relative URLs
  private val httpProtocol = http.baseUrl("https://gatling.io")

  // A scenario is a chain of requests and pauses
  private val scn = scenario("Scenario Name")
      .exec(
        http("request_1").get("/")
      )

  before {
    println("Simulation is about to start!")
  }

  setUp(scn.inject(atOnceUsers(1)).protocols(httpProtocol))

  after {
    println("Simulation is finished!")
  }
}