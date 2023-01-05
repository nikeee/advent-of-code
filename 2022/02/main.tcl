#!/usr/bin/env tclsh

# Run:
#     ./main.tcl < input.txt


while {![eof stdin]} {
	gets stdin line
	if {![string equal {} $line]} {
		lappend lines $line
	}
}

proc map {fun list} {
	set res {}
	foreach element $list {lappend res [$fun $element]}
	set res
}

# https://wiki.tcl-lang.org/page/Summing+a+list
proc ladd L {expr [join $L +]+0} ;# RS

proc move_value {move} {
	switch $move {
		A { return 1 }
		B { return 2 }
		C { return 3 }
		X { return 1 }
		Y { return 2 }
		Z { return 3 }
	}
}

proc game_outcome_part1 {own_move opponent_move} {
	switch $own_move {
		X {
			switch $opponent_move {
				A { return 3 }
				B { return 0 }
				C { return 6 }
			}
		}
		Y {
			switch $opponent_move {
				A { return 6 }
				B { return 3 }
				C { return 0 }
			}
		}
		Z {
			switch $opponent_move {
				A { return 0 }
				B { return 6 }
				C { return 3 }
			}
		}
	}
}

proc get_game_score_part1 {spec} {
	set opponent_move [lindex $spec 0]
	set own_move [lindex $spec 1]

	set own_move_value [move_value $own_move]
	set outcome [game_outcome_part1 $own_move $opponent_move]
	return [expr $own_move_value + $outcome]
}

set rounds_part1 [map get_game_score_part1 $lines]
set part_1 [ladd $rounds_part1]

puts "Points after applying the strategy guide; Part 1: $part_1"


proc game_outcome_part2 {own_move opponent_move} {
	switch $own_move {
		A {
			switch $opponent_move {
				A { return 3 }
				B { return 0 }
				C { return 6 }
			}
		}
		B {
			switch $opponent_move {
				A { return 6 }
				B { return 3 }
				C { return 0 }
			}
		}
		C {
			switch $opponent_move {
				A { return 0 }
				B { return 6 }
				C { return 3 }
			}
		}
	}
}

proc get_required_move_for_target {opponent_move target_result} {
	switch $opponent_move {
		A {
			switch $target_result {
				# lose
				X { return C }
				# tie
				Y { return A }
				# win
				Z { return B }
			}
		}
		B {
			switch $target_result {
				# lose
				X { return A }
				# tie
				Y { return B }
				# win
				Z { return C }
			}
		}
		C {
			switch $target_result {
				# lose
				X { return B }
				# tie
				Y { return C }
				# win
				Z { return A }
			}
		}
	}
}

proc get_game_score_part2 {spec} {
	set opponent_move [lindex $spec 0]
	set target_result [lindex $spec 1]

	set move_to_take [get_required_move_for_target $opponent_move $target_result]
	set own_move_value [move_value $move_to_take]
	set score [game_outcome_part2 $move_to_take $opponent_move]
	return [expr $own_move_value + $score]
}

set rounds_part2 [map get_game_score_part2 $lines]
set part_2 [ladd $rounds_part2]

puts "Points after applying the correct strategy guide; Part 2: $part_2"
