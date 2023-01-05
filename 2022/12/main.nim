# Compile:
#     nim c -d:release main.nim
# Use:
#     ./main < input.txt
# Compiler version:
#     nim --version
#     Nim Compiler Version 1.6.10 [Linux: amd64]

import sequtils
import std/[sets, deques, tables, options]

type Point = tuple[x: int, y: int]

var height_map = stdin.lines
    .toSeq()
    .mapIt(it.mapIt(it.ord - 'a'.ord))

let width = height_map[0].len
let height = height_map.len

var start_point: Point
var end_point: Point
for y in 0 ..< height:
    for x in 0 ..< width:
        if height_map[y][x] == 'S'.ord - 'a'.ord:
            start_point = (x, y)
            # fix height map, so that the start has the lowest elevation (0)
            height_map[y][x] = 'a'.ord - 'a'.ord
        if height_map[y][x] == 'E'.ord - 'a'.ord:
            end_point = (x, y)
            # fix height map, so that the end has the highest elevation (25)
            height_map[y][x] = 'z'.ord - 'a'.ord


func build_path(parents: Table[Point, Point], end_point: Point): seq[Point] =
    var res = @[end_point]
    var current = end_point
    while current in parents:
        current = parents[current]
        res.add(current)
    return res


# We could get fancy with a dijkstra or A* here, but a simple BFS is enough for our case
func bfs(height_map: seq[seq[int]], start_point: Point, end_point: Point, width: int, height: int): Option[seq[Point]] =
    var queue = [start_point].toDeque()
    var visited = initHashSet[Point]()
    var parents = initTable[Point, Point]()

    while queue.len > 0:
        let current = queue.popFirst()
        visited.incl(current)

        if current == end_point:
            return some(build_path(parents, current))

        let neighbors = [
            Point (current.x - 1, current.y),
            Point (current.x + 1, current.y),
            Point (current.x, current.y - 1),
            Point (current.x, current.y + 1),
        ]

        let current_height = height_map[current.y][current.x]

        for neighbor in neighbors:
            if neighbor.x < 0 or neighbor.x >= width or neighbor.y < 0 or neighbor.y >= height:
                continue
            if neighbor in visited:
                continue
            if neighbor in queue:
                continue

            let neighbor_height = height_map[neighbor.y][neighbor.x]

            # The neighbor must be at most 1 unit higher than the current
            # but we always allow going down by _any_ amount
            if neighbor_height - current_height > 1:
                continue

            queue.addLast(neighbor)
            visited.incl(neighbor)
            parents[neighbor] = current

    return none(seq[Point])

let shortest_path = bfs(height_map, start_point, end_point, width, height).get()
echo "Fewest steps required to reach the top; Part 1: ", shortest_path.len - 1

var possible_start_points = initHashSet[Point]()
for y in 0 ..< height:
    for x in 0 ..< width:
        if height_map[y][x] == 0:
            possible_start_points.incl(Point (x, y))

let part2 = possible_start_points
    .mapIt(bfs(height_map, it, end_point, width, height))
    .filterIt(it.isSome)
    .mapIt(it.get().len - 1)
    .min()
echo "Fewest steps from some point with lowest elevation; Part 2: ", part2
