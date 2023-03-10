# Advent of Code 2021
...with a different language on each day.

To see how to run the solutions of each individual day, look at its main source file.

| Day | Task                                                            | Solution   | Language                                                                | Problem/Topic/Solution                                                 |
|-----|-----------------------------------------------------------------|------------|-------------------------------------------------------------------------|------------------------------------------------------------------------|
| 1   | [Sonar Sweep](https://adventofcode.com/2021/day/1)              | [Link](01) | [Tcl](https://en.wikipedia.org/wiki/Tcl)                                | Sliding Windows (Part 2)                                               |
| 2   | [Dive!](https://adventofcode.com/2021/day/2)                    | [Link](02) | [Haskell](https://en.wikipedia.org/wiki/Haskell_(programming_language)) |                                                                        |
| 3   | [Binary Diagnostic](https://adventofcode.com/2021/day/3)        | [Link](03) | [F#](https://en.wikipedia.org/wiki/F_Sharp_(programming_language))      |                                                                        |
| 4   | [Giant Squid](https://adventofcode.com/2021/day/4)              | [Link](04) | [C](https://en.wikipedia.org/wiki/C_(programming_language))             | Bingo                                                                  |
| 5   | [Hydrothermal Venture](https://adventofcode.com/2021/day/5)     | [Link](05) | [Haxe](https://en.wikipedia.org/wiki/Haxe)                              |                                                                        |
| 6   | [Lanternfish](https://adventofcode.com/2021/day/6)              | [Link](06) | [Scala](https://en.wikipedia.org/wiki/Scala_(programming_language))     | Modeling exponential growth                                            |
| 7   | [The Treachery of Whales](https://adventofcode.com/2021/day/7)  | [Link](07) | [R](https://en.wikipedia.org/wiki/R_(programming_language))             |                                                                        |
| 8   | [Seven Segment Search](https://adventofcode.com/2021/day/8)     | [Link](08) | [Prolog](https://en.wikipedia.org/wiki/Prolog)                          | [CSP](https://en.wikipedia.org/wiki/Constraint_satisfaction_problem)   |
| 9   | [Smoke Basin](https://adventofcode.com/2021/day/9)              | [Link](09) | [Julia](https://en.wikipedia.org/wiki/Julia_(programming_language))     |                                                                        |
| 10  | [Syntax Scoring](https://adventofcode.com/2021/day/10)          | [Link](10) | [Crystal](https://en.wikipedia.org/wiki/Crystal_(programming_language)) |                                                                        |
| 11  | [Dumbo Octopus](https://adventofcode.com/2021/day/11)           | [Link](11) | [VB.NET](https://en.wikipedia.org/wiki/Visual_Basic_.NET)               | [Cellular Automaton](https://en.wikipedia.org/wiki/Cellular_automaton) |
| 12  | [Passage Pathing](https://adventofcode.com/2021/day/12)         | [Link](12) | [SQL](https://en.wikipedia.org/wiki/SQLite)                             | Number of paths in a graph                                             |
| 13  | [Transparent Origami](https://adventofcode.com/2021/day/13)     | [Link](13) | [Nim](https://en.wikipedia.org/wiki/Nim_(programming_language))         | Folding a sheet of paper                                               |
| 14  | [Extended Polymerization](https://adventofcode.com/2021/day/14) | [Link](14) | [PHP](https://en.wikipedia.org/wiki/PHP)                                |                                                                        |
| 15  | [Chiton](https://adventofcode.com/2021/day/15)                  | [Link](15) | [Dart](https://en.wikipedia.org/wiki/Dart_(programming_language))       | Cheapest path / A*                                                     |
| 16  | [Packet Decoder](https://adventofcode.com/2021/day/16)          | [Link](16) | [Swift](https://en.wikipedia.org/wiki/Swift_(programming_language))     | Parsing binary data +  expression evaluation                           |
| 17  | [Trick Shot](https://adventofcode.com/2021/day/17)              | [Link](17) | [D](https://en.wikipedia.org/wiki/D_(programming_language))             | Simulating a trajectory                                                |
| 18  | [Snailfish](https://adventofcode.com/2021/day/18)               | [Link](18) | [Java](https://en.wikipedia.org/wiki/Java_(programming_language))       | Syntax tree transformations, cartesian product                         |
| 19  | [Beacon Scanner](https://adventofcode.com/2021/day/19)          | [Link](19) | [C#](https://en.wikipedia.org/wiki/C_Sharp_(programming_language))      |                                                                        |
| 20  | [Trench Map](https://adventofcode.com/2021/day/20)              | [Link](20) | [Rust](https://en.wikipedia.org/wiki/Rust_(programming_language))       |                                                                        |
| 21  | [Dirac Dice](https://adventofcode.com/2021/day/21)              | [Link](21) | [Python](https://en.wikipedia.org/wiki/Python_(programming_language))   |                                                                        |
| 22  | [Reactor Reboot](https://adventofcode.com/2021/day/22)          | [Link](22) | [V](https://vlang.io)                                                   |                                                                        |
| 23  | [Amphipod](https://adventofcode.com/2021/day/23)                | [Link](23) | [Kotlin](https://en.wikipedia.org/wiki/Kotlin_(programming_language))   |                                                                        |

# Observations
## Haxe
Last year, the first time I used Haxe, it felt like Java with some extra syntax, but basically the same regarding the philosophy. It's seems that it's still like this. Also, basic stuff is missing, like a `Math.min/max/sign` for integers.
## R
I like the idea of the [`~` operator in R](https://stackoverflow.com/questions/14976331).

[When using purrr](https://coolbutuseless.github.io/2019/03/13/anonymous-functions-in-r-part-1/) and passing functions (or formulas) to a function `f`, you can access other named arguments of `f` inside the "lambda" function (function expression) or formula.

## Prolog
Doing something in Prolog is _very_ different. It has been an interesting experience; would recommend 10/10. Implementing stuff feels like a giant [Query-By-Example](https://en.wikipedia.org/wiki/Query_by_Example) or a variation of the tuple calculus.

## Julia
In Julia, functions that mutate state of their arguments have ([by convention only](https://docs.julialang.org/en/v1/manual/style-guide/#bang-convention)) an exclamation mark in their name, for example `push!`, which is an interesting idea.

I enjoyed using Julia and will definitely use it again, although it uses 1-based array indices.

## Crystal
Neat ideas: Functions that return boolean values have a name ending in `?`. Methods ending in `!` mutate the `this` object.

## Nim
Python-inspired, compiled language with side-effect tracking. Functions (`func`) can be marked to have side-effects, which can ensure purity. I'll definitely use it again.

## PHP
PHP has gotten a lot better since the 5.x days, especially with type hints and a shorter syntax for anonymous functions.

## Dart
Basically feels like Haxe (see above) done a couple of years later.

## Swift
It seems that stuff that once was deprecated actually will get removed entirely, which is a good thing. The bad thing is that a lot of stuff that one can find on StackOverflow just does not even compile. An unusual problem, but works. A lot of posts on SO contain solutions to multiple versions of Swift.

Handling strings is a bit cumbersome due to the distinction between `Int`s and `String.Index`. But it seems to be necessary, considering unicode support. I ended up using and extending [a random extension to `String`](https://stackoverflow.com/a/26775912), which removed a lot of boilerplate code. I also considered switching to a `Character` array, but that also [changed a lot](https://stackoverflow.com/a/25921323) during the language evolution.
