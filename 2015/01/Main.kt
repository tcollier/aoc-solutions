import java.io.File
import java.io.InputStream

import tcollier.AocExecutor

fun part1Answer(input: List<String>): String {
  var floor = 0
  val line = input[0]
  for (i in 0 until line.length) {
    if (line[i] == '(') {
      floor++
    } else if (line[i] == ')') {
      floor--
    }
  }
  return floor.toString()
}

fun part2Answer(input: List<String>): String {
  var floor = 0
  val line = input[0]
  for (i in 0 until line.length) {
    if (line[i] == '(') {
      floor++
    } else if (line[i] == ')') {
      floor--
    }
    if (floor < 0) {
      return (i + 1).toString()
    }
  }
  return "Not found"
}

fun main(args: Array<String>) {
    val input = mutableListOf<String>()
    val inputStream: InputStream = File("2015/01/input.txt").inputStream()
    inputStream.bufferedReader().forEachLine { input.add(it) }
    val executor = AocExecutor(input, ::part1Answer, ::part2Answer)
    executor.run(args)
}
