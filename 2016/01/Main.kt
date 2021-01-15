import java.io.File
import java.io.InputStream

import tcollier.AocExecutor

data class Complex(val real: Int = 0, val imag: Int = 0)

operator fun Complex.plus(c: Complex): Complex{
  return Complex(this.real + c.real, this.imag + c.imag)
}

operator fun Complex.times(c: Complex): Complex{
  return Complex(this.real * c.real - this.imag * c.imag, this.imag * c.real + this.real * c.imag)
}

fun part1Answer(input: List<String>): String {
  var position = Complex(0, 0)
  var bearing = Complex(0, 1)

  for (dir in input) {
    if (dir[0] == 'R') {
      bearing *= Complex(0, -1)
    } else if (dir[0] == 'L') {
      bearing *= Complex(0, 1)
    }

    val mag = dir.substring(1, dir.length).toInt()
    position += bearing * Complex(mag, 0)
  }
  return (Math.abs(position.real) + Math.abs(position.imag)).toString()
}

fun intersection(h1: Complex, h2: Complex, v1: Complex, v2: Complex): Complex? {
  var minX = h1.real
  var maxX = h2.real
  if (minX > maxX) {
    minX = minX xor maxX
    maxX = minX xor maxX
    minX = minX xor maxX
  }
  if (!(v1.real in minX..maxX)) {
    return null
  }
  var minY = v1.imag
  var maxY = v2.imag
  if (minY > maxY) {
    minY = minY xor maxY
    maxY = minY xor maxY
    minY = minY xor maxY
  }
  if (!(h1.imag in minY..maxY)) {
    return null
  }
  return Complex(v1.real, h1.imag)
}

fun part2Answer(input: List<String>): String {
  var position = Complex(0, 0)
  var bearing = Complex(0, 1)
  var visited = mutableSetOf<Complex>()
  visited.add(position)

  for (dir in input) {
    if (dir[0] == 'R') {
      bearing *= Complex(0, -1)
    } else if (dir[0] == 'L') {
      bearing *= Complex(0, 1)
    }

    val mag = dir.substring(1, dir.length).toInt()
    for (i in 1..mag) {
      position += bearing * Complex(1, 0)
      if (position in visited) {
        return (Math.abs(position.real) + Math.abs(position.imag)).toString()
      } else {
        visited.add(position)
      }
    }
  }
  return "Not Found"
}

fun main(args: Array<String>) {
    var lines = mutableListOf<String>()
    val inputStream: InputStream = File("2016/01/input.txt").inputStream()
    inputStream.bufferedReader().forEachLine { lines.add(it) }
    val input = lines[0].split(", ")
    val executor = AocExecutor(input, ::part1Answer, ::part2Answer)
    executor.run(args)
}
