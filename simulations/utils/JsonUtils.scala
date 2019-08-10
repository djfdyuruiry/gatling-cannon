package utils

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.scala.DefaultScalaModule
import com.fasterxml.jackson.module.scala.experimental.ScalaObjectMapper

object JsonUtils {
  private val objectMapper = {
    val objectMapper = new ObjectMapper() with ScalaObjectMapper

    objectMapper.registerModule(DefaultScalaModule)
    objectMapper
  }

  def toJson(value: Any): String = {
    objectMapper.writeValueAsString(value)
  }

  def fromJson[T](json: String, clazz: Class[T]): T = {
    objectMapper.readValue(json, clazz)
  }
}
