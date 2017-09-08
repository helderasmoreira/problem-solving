object CountingSheep extends App {
  def solve(test: Int) = {
    val seen = Array.fill(10)(false)

    val n = readInt
    var x = 0

    do {
      x += n
      x.toString.foreach { c => seen(c.asDigit) = true }
    }
    while(seen.contains(false) && (x != x+n))

    val res = if(seen.contains(false)) "INSOMNIA" else x
    println(s"Case #$test: $res")
  }

  // Console.setIn(new java.io.BufferedInputStream(new java.io.FileInputStream("really-small-input.in")))
  // Console.setOut(new java.io.BufferedOutputStream(new java.io.FileOutputStream("really-small-input.out")))

  // Console.setIn(new java.io.BufferedInputStream(new java.io.FileInputStream("A-small-practice.in")))
  // Console.setOut(new java.io.BufferedOutputStream(new java.io.FileOutputStream("A-small-practice.out")))

  Console.setIn(new java.io.BufferedInputStream(new java.io.FileInputStream("A-large-practice.in")))
  Console.setOut(new java.io.BufferedOutputStream(new java.io.FileOutputStream("A-large-practice.out")))

  for (test <- 1 to readInt) {
    solve(test)
    Console.flush
  }
}
