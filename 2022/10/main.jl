#!/usr/bin/env julia
# Run:
#     ./main.jl < input.txt
# Version:
#     julia --version
#     julia version 1.8.3

using Printf

instructions = map(line -> split(line, " "), readlines())

function createsprite(x)
    pixel = "#"
    empty = "."

    sprite = ""
    # negative x is allowed because x represents the position of the _center_ of the sprite
    if x == -1
        sprite = pixel ^ 1
    elseif x == 0
        sprite = pixel ^ 2
    else
        sprite = empty^(x - 1) * pixel ^ 3
    end
    return rpad(sprite, 40, empty)
end

function getpixel(sprite, cycle)
    pos = mod(cycle, 40)
    r = sprite[begin + pos]
    return r
end

function run(instructions)
    signalstrengths = 0

    ip = 1 # in julia, array start at 1
    cycle = 0
    cyclesininstruction = 0

    x = 1
    sprite = createsprite(1)

    rows = []
    currentrow = ""

    while ip <= length(instructions)
        current = instructions[ip]

        # kept here for part 1
        if cycle == 20 || mod(cycle - 20, 40) == 0
            signalstrengths += cycle * x
        end

        if current[1] == "noop"
            if cyclesininstruction == 1
                ip += 1
                cyclesininstruction = 0
            end
        elseif current[1] == "addx"
            # Instruction just finised, go to next instruction and update x
            if cyclesininstruction == 2
                x += parse(Int, current[2])
                # reconfigure sprite for part 2
                sprite = createsprite(x)

                ip += 1
                cyclesininstruction = 0
            end
        end

        # used for scanning in part 2
        currentrow *= getpixel(sprite, cycle)

        cyclesininstruction += 1
        cycle += 1

        if mod(cycle, 40) == 0
            push!(rows, currentrow)
            currentrow = ""
        end
    end

    push!(rows, currentrow)

    return signalstrengths, rows
end

part1, part2 = run(instructions)
@printf("Sum of six selected signal strengths; Part 1: %d\n", part1)

@printf("Image returned if screen is rendered properly; Part 2:\n")
for line in part2
    line = replace(line, "." => " ")
    println(
        replace(line, "#" => "\u001b[33m█\u001b[0m")
    )
end
