// Compile:
//     gcc -std=c2x -O4 -Wall -Wextra main.c -o main
// Run:
//     ./main < input.txt
// Version:
//    gcc --version
//    gcc (Ubuntu 12.2.0-3ubuntu1) 12.2.0

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

typedef struct {
    char direction;
    size_t amount;
} Move;

typedef struct {
    int x;
    int y;
} Position;

//#region "Set" implementation that's actually an array list

/**
 * It's not a set, it's an array list.
 * However, we're going to do linear scans on this bad boy to keep things simple (I don't want to include a proper set implementation).
 * We don't have much items, so this should suffice.
 */
typedef struct {
    size_t count;
    size_t capacity;
    Position* data;
} CheapSet;

CheapSet cheap_set_new(size_t capacity) {
    CheapSet result = {};
    result.count = 0;
    result.capacity = capacity;
    result.data = calloc(capacity, sizeof(Position));
    return result;
}

/** Time complexity O(n) with n being the number of items currently in the "set". */
bool cheap_set_contains(CheapSet *set, Position pos) {
    for(size_t i = 0; i < set->count; ++i) {
        Position item = set->data[i];
        if (item.x == pos.x && item.y == pos.y) {
            return true;
        }
    }
    return false;
}

/** Time complexity O(n) with n being the number of items currently in the "set". */
bool cheap_set_add(CheapSet *set, Position pos) {
    if (cheap_set_contains(set, pos)) {
        return false;
    }

    if (set->count == set->capacity) {
        size_t new_capacity = set->capacity * 2;
        Position* new_data = realloc(set->data, new_capacity * sizeof(Position));
        if (!new_data) {
            return false;
        }
        set->data = new_data;
        set->capacity = new_capacity;
    }

    set->data[set->count] = pos;
    ++set->count;
    return true;
}

void cheap_set_free(CheapSet *set) {
    free(set->data);
}

//#endregion

/** @remarks Does hidden allocation */
Move* read_input(size_t *moves_count) {
    size_t moves_capacity = 100;
    Move* moves = calloc(moves_capacity, sizeof(Move));
    if (!moves) {
        goto ERR_EARLY;
    }

    size_t moves_length = 0;
    while (true) {
        if (moves_capacity <= moves_length) {
            moves_capacity *= 2;
            Move* new_moves = realloc(moves, moves_capacity * sizeof(Move));
            if (!new_moves) {
                goto ERR_FREE;
            }
            moves = new_moves;
        }

        char direction = '\0';
        int amount = 0;

        // Leading space to fix line breaks in input
        if (scanf(" %c %d", &direction, &amount) != 2) {
            break;
        }

        moves[moves_length].direction = direction;
        moves[moves_length].amount = amount;
        ++moves_length;
    }

    *moves_count = moves_length;
    return moves;

ERR_FREE:
    free(moves);
ERR_EARLY:
    *moves_count = 0;
    return NULL;
}

bool is_near(Position head, Position tail) {
    return abs(tail.x - head.x) <= 1 && abs(tail.y - head.y) <= 1;
}

bool move(CheapSet *visited, size_t knot_count, Position knots[knot_count], Move move) {

    for(size_t i = 0; i < move.amount; ++i) {
        // Move the head first and derive the tail movement from that
        switch (move.direction) {
            case 'R':
                ++knots[0].x;
                break;
            case 'L':
                --knots[0].x;
                break;
            case 'U':
                ++knots[0].y;
                break;
            case 'D':
                --knots[0].y;
                break;
            default:
                return false;
        }

        for (size_t i = 1; i < knot_count; ++i) {
            Position* preceding_knot = &knots[i - 1];
            Position* current_knot = &knots[i];

            if (!is_near(*preceding_knot, *current_knot)) {
                const int dx = current_knot->x - preceding_knot->x;
                const int dy = current_knot->y - preceding_knot->y;

                if (dx > 1) {
                    current_knot->x = preceding_knot->x + 1;
                } else if (dx > 0) {
                    current_knot->x = preceding_knot->x;
                } else if (dx < -1) {
                    current_knot->x = preceding_knot->x - 1;
                } else if (dx < 0) {
                    current_knot->x = preceding_knot->x;
                }

                if (dy > 1) {
                    current_knot->y = preceding_knot->y + 1;
                } else if (dy > 0) {
                    current_knot->y = preceding_knot->y;
                } else if (dy < -1) {
                    current_knot->y = preceding_knot->y - 1;
                } else if (dy < 0) {
                    current_knot->y = preceding_knot->y;
                }
            }
        }

        cheap_set_add(visited, knots[knot_count - 1]);
    }

    return true;
}

size_t perform_rope_head_moves(size_t moves_count, Move moves[moves_count], size_t knot_count) {
    Position *knots = calloc(knot_count, sizeof(Position));
    if (!knots) {
        return 0;
    }

    CheapSet visited = cheap_set_new(10000);
    cheap_set_add(&visited, knots[knot_count - 1]);

    for (size_t i = 0; i < moves_count; ++i) {
        bool res = move(&visited, knot_count, knots, moves[i]);
        if (!res) {
            free(knots);
            return 0;
        }
    }

    free(knots);
    size_t result = visited.count;
    cheap_set_free(&visited);
    return result;
}

int main() {
    size_t moves_count = 0;
    Move* moves = read_input(&moves_count);
    if (!moves) {
        goto ERR_UNABLE_TO_READ_INPUT;
    }

    size_t visited_part1 = perform_rope_head_moves(moves_count, moves, 2);
    if (!visited_part1) {
        goto ERR_MOVE;
    }
    printf("Number of positions the tail of the rope visited; Part 1: %ld\n", visited_part1);

    size_t visited_part2 = perform_rope_head_moves(moves_count, moves, 10);
    if (!visited_part2) {
        goto ERR_MOVE;
    }
    printf("Number of positions the tail of the rope visited; Part 1: %ld\n", visited_part2);

    return EXIT_SUCCESS;

ERR_MOVE:
    free(moves);
ERR_UNABLE_TO_READ_INPUT:
    return EXIT_FAILURE;
}
