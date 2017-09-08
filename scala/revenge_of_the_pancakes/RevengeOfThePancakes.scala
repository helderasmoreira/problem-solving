object RevengeOfThePancakes extends App {
  def parse: List[Boolean] = readLine.toList.map(_ == '+')
  def happy(pancakes: List[Boolean]): Boolean = pancakes.forall(_ == true)

  def sameUntil(pancakes: List[Boolean]) : Int = {
    val index = pancakes.indexOf(!pancakes.head)
    if(index == -1) pancakes.size
    else index
  }

  def flip(pancakes: List[Boolean], n: Int): List[Boolean] = pancakes.splitAt(n) match { case(pt1, pt2) =>
    pt1.map(_ == false).reverse ::: pt2
  }

  def solve_aux(pancakes: List[Boolean], moves: Int) : Int = {
    if (happy(pancakes)) moves
    else {
      val flipped = flip(pancakes, sameUntil(pancakes))
      solve_aux(flipped, moves + 1)
    }
  }

  def solve(test: Int) = {
    val moves = solve_aux(parse, 0)
    println(s"Case #$test: $moves")
  }

  // Console.setIn(new java.io.BufferedInputStream(new java.io.FileInputStream("really-small-input.in")))

  // Console.setIn(new java.io.BufferedInputStream(new java.io.FileInputStream("B-small-practice.in")))
  // Console.setOut(new java.io.BufferedOutputStream(new java.io.FileOutputStream("B-small-practice.out")))

  Console.setIn(new java.io.BufferedInputStream(new java.io.FileInputStream("B-large-practice.in")))
  Console.setOut(new java.io.BufferedOutputStream(new java.io.FileOutputStream("B-large-practice.out")))

  for (test <- 1 to readInt) {
    solve(test)
    Console.flush
  }
}
