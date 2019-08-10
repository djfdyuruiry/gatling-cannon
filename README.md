# gatling-cannon

A template performance test project built using Gatling and Scala. Includes everything you need to start writing, debugging and executing simulations.

----

## Overview

- Gatling v3.20, Scala v2.12, JDK 11 and Gradle v5
- Code for Gatling simulations is stored in the `simulations` directory
- Gatling is downloaded and configured automatically, into the `gatling-bundle` directory
- Multiple simulations can be executed in parallel
- Debugger for Gatling Simulations
- IntelliJ project and run configurations included

----

## Running Simulations:

To Run a simulation, simply run:

```shell
  runSimulation.sh <simulationClass>
```

- Run multiple simulations at once by executing:

```shell
  runSimulations.sh <simulationClass1>,<simulationClass2>
```

*If you name your simulation files to end in 'Simulation.scala' the runSimulations script will automatically detect them if you don't pass a CSV list*

- View results in the `results` directory

----

## Example Simulation:

A simple simulation based on Gatling docs is provided in the `simulations` directory, in the class `example.SampleSimulation`.

To run it:

```shell
  runSimulation.sh example.SampleSimulation
```

----

## Setup 

- Install [JDK 11](https://adoptopenjdk.net/)
- Install [IntelliJ IDEA](https://www.jetbrains.com/idea/download)
    - Install the [Scala Plugin](https://plugins.jetbrains.com/plugin/1347-scala) for IntelliJ
    - Install the [Bash Support](https://plugins.jetbrains.com/plugin/4230-bashsupport) for IntelliJ
- Install the [Scala SDK](https://www.scala-lang.org/) 2.12.8

*I recommend using [SDKMAN!](https://sdkman.io/) to install Java & Scala*

----

## IntelliJ Project

The IntelliJ project has been configured to provide look-ups for the Gatling libraries and run the tests in quick way to enable rapid development.

- Open IntelliJ preferences and go to `Tools` > `External Tools` and add a new tool, name it `Dump Current IntelliJ File` and set:
  - Program: `sh`
  - Arguments: `-c "printf $FileFQPackage$.$FileNameWithoutAllExtensions$ > .currentIntelliJFile"`
  - Working Directory: `$ProjectFileDir$`
- Open the directory in IntelliJ
  - Select the repository directory
  - Check `auto import` when asked to configure gradle
- You may be prompted to install a Scala SDK, if so click `Download...` when choosing a version and select `2.12`
- To run the tests go to the `run` menu and select `Run Tests`
- To run a specific simulation, open the simulation class and go to the `run` menu and select `Run current simulation` 

### Debugging Simulation Code

There are run configurations to debug the Gatling simulations by running them in a standalone scala app.

- Place your breakpoints or whatever you wish to do
- Go to the `run` menu and select `Debug Tests`
- Click the `debug` icon

To debug the current simulation:

- Go to the `run` menu and select `Debug Current Simulation`
- Click the `debug` icon

---

## Adding a Code Dependency

- Open `build.gradle`
- Add a new library to the `dependencies` section prefixed with `implementation`
    - If the library references a scala, gatling or jackson version in it's version/name, use the `ext` variables in `build.gradle` to substitute those values
    ```
      implementation "com.fasterxml.jackson.module:jackson-module-scala_${scalaMajorVersion}:${jacksonVersion}"
    ```
- Refresh libraries by running
   ```
     ./gradlew
   ```

_Libraries managed by Gradle are are automatically copied to Gatling when you launch the tests from the command line or IntelliJ_

---

## Builtin Utilities

I have included a few useful utilities that I use when building Gatling simulations, these can be found in the `simulations` directory:

`utils.GatlingDebugger`: this is a main class that calls Gatling programmatically to run one or more simulations

`utils.JsonUtils`: wrapper around the [Jackson Scala Module](https://github.com/FasterXML/jackson-module-scala) which allows JSON deserializing/serializing of Scala types such as `case` classes

----

## Upgrading Gatling

You can change the Gatling version by setting the `gatlingVersion` ext variable in `build.gradle`.

Use `+` to default to the latest version and then change it to the version that gradle installs after upgrading, and before you commit the change.
