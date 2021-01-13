import java.io.File
import java.io.InputStream

import tcollier.AocExecutor

fun part1Answer(input: List<Int>): String {
    for (i in 0..input.size-2) {
        for (j in i+1..input.size-1) {
            if (input[i] + input[j] == 2020) {
                return (input[i] * input[j]).toString()
            }
        }
    }
    return "Not Found"
}

fun part2Answer(numbers: List<Int>): String {
    val input = numbers.toMutableList()
    input.sort()
    for (i in 0..input.size-3) {
        var j = i + 1
        var k = input.size - 1
        while (j < k) {
            val sum = input[i] + input[j] + input[k]
            if (sum == 2020) {
                return (input[i] * input[j] * input[k]).toString()
            } else if (sum < 2020) {
                j++
            } else {
                k--
            }
        }
    }
    return "Not Found"
}

fun main(args: Array<String>) {
    val input = mutableListOf<Int>()
    val inputStream: InputStream = File("2020/01/input.txt").inputStream()
    inputStream.bufferedReader().forEachLine { input.add(it.toInt()) }
    val executor = AocExecutor(input, ::part1Answer, ::part2Answer)
    executor.run(args)
}
