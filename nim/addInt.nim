from strutils import parseInt, split

echo("Input two numbers, please: ")
let nums = split(readLine(stdin))
let x = parseInt(nums[0])
let y = parseInt(nums[1])
echo(x + y)
