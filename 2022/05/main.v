// Compile:
//     v main.v
// Use:
//     ./main < input.txt
// Compilier Version:
//     v version
//     V 0.3.2 58e150d

import os

struct Instruction {
	amount int
	from_index usize
	to_index usize
}

fn main() {
	input := os.get_raw_lines_joined().split("\n\n")

	initial_stack_config := input[0].split("\n")
	instructions := input[1].trim("\n")

	stacks := parse_stacks(initial_stack_config)
	parsed_instructions := parse_instructions(instructions)

	result_stacks_part1 := process_instructions_part1(stacks, parsed_instructions)
	part1_solution := read_top_crates(result_stacks_part1)
	println("Top crates after following move instructions; Part 1: ${part1_solution}")

	result_stacks_part2 := process_instructions_part2(stacks, parsed_instructions)
	part2_solution := read_top_crates(result_stacks_part2)
	println("Top crates after following move instructions with different cranes; Part 2: ${part2_solution}")
}

fn parse_stacks(initial_stack_config []string) [][]rune {

	number_of_stacks := initial_stack_config.last().replace(" ", "").len

	mut stacks := [][]rune{len: number_of_stacks, init: []rune{}}

	// - 2 becase we want to skip the labeling section
	for layer := (initial_stack_config.len - 2); layer >= 0; layer-- {

		for column := 1; column < initial_stack_config[layer].len; column += 4 {
			crate := initial_stack_config[layer][column]
			if crate != ` ` {
				stacks[(column - 1) / 4] << crate
			}
		}

	}
	return stacks
}

fn parse_instructions(value string) []Instruction {
	mut result := []Instruction{}
	for line in value.split("\n") {
		// Sample line:
		// "move 1 from 2 to 1"
		parts := line.split(" ")

		result << Instruction {
			amount: parts[1].int(),
			from_index: usize(parts[3].int() - 1),
			to_index: usize(parts[5].int() - 1),
		}
	}
	return result
}

fn process_instructions_part1(initial_stacks [][]rune, instructions []Instruction) [][]rune {
	mut stacks := initial_stacks.clone()
	for instruction in instructions {
		for _ in 0..instruction.amount {
			stacks[instruction.to_index] << stacks[instruction.from_index].pop()
		}
	}
	return stacks
}

fn process_instructions_part2(initial_stacks [][]rune, instructions []Instruction) [][]rune {
	mut stacks := initial_stacks.clone()
	for instruction in instructions {
		stacks[instruction.to_index] << stacks[instruction.from_index]#[-instruction.amount..]
		stacks[instruction.from_index].trim(stacks[instruction.from_index].len - instruction.amount)
	}
	return stacks
}

fn read_top_crates(stacks [][]rune) string {
	mut top_elements := ""
	for stack in stacks {
		top_elements += stack.last().str()
	}
	return top_elements
}