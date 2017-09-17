// https://www.reddit.com/r/dailyprogrammer/comments/6vi9ro/170823_challenge_328_intermediate_pyramid_sliding/

import scala.util.Try

object PyramidSliding extends App {
  def solve() = {
    var pyramid: List[Array[Int]] = List()

    for (test <- 1 to readInt) {
      pyramid = pyramid :+ readLine.split(" ").map(_.toInt)
    }

    for (vertical <- (pyramid.size-1) to 1 by -1) {
      for (horizontal <- 0 to (pyramid(vertical-1).size-1)) {
        pyramid(vertical-1)(horizontal) = List(pyramid(vertical)(horizontal), pyramid(vertical)(horizontal+1)).min + pyramid(vertical-1)(horizontal)
      }
    }

    println(pyramid.head(0))
  }

  // Console.setIn(new java.io.BufferedInputStream(new java.io.FileInputStream("challenge-1.in")))
  // Console.setOut(new java.io.BufferedOutputStream(new java.io.FileOutputStream("challenge-1.out")))

  // Console.setIn(new java.io.BufferedInputStream(new java.io.FileInputStream("challenge-2.in")))
  // Console.setOut(new java.io.BufferedOutputStream(new java.io.FileOutputStream("challenge-2.out")))

  Console.setIn(new java.io.BufferedInputStream(new java.io.FileInputStream("challenge-3.in")))
  Console.setOut(new java.io.BufferedOutputStream(new java.io.FileOutputStream("challenge-3.out")))

  solve()
  Console.flush
}
