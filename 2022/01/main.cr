# Compile:
#     crystal build --release main.cr
# Use:
#     ./main < input.txt
# Compiler version:
#     crystal --version
#     Crystal 1.6.2 [879691b2e] (2022-11-03)

meals_for_each_elf = STDIN
  .gets_to_end
  .strip('\n')
  .split("\n\n")

calories_per_elf = meals_for_each_elf
  .map { |elf_meals| elf_meals.split('\n').map { |meal| meal.to_i }.sum }

part_1 = calories_per_elf.max

puts "Calories of elf with the meals with the most calories; Part 1: #{part_1}"

part_2 = calories_per_elf
  .sort { |a, b| b <=> a }
  .first(3)
  .sum()

puts "Sum of calories of top three elves; Part 2: #{part_2}"
