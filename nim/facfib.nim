from strutils import parseInt

proc factorial(n: int): int =
    case n
    of 0..1: result = 1
    else: result = n * factorial(n - 1)


proc fibonacci(n: int): int =
    case n
    of 0: result = 0
    of 1: result = 1
    else: result = fibonacci(n - 1) + fibonacci(n - 2)

echo("Input number to calculate factorial for: ")
let n = parseInt(readLine(stdin))
if n <= 20:
    echo("Factorial: ", factorial(n))
echo("Fibonacci: ", fibonacci(n))
