import os

enum Direction {
	up
	right
	down
	left
	none
}

fn main() {
	grid := os.read_lines('puzzle.input')!

	mut guard := Agent{
		max_y:      grid.len
		max_x:      grid[0].len
		y:          -1
		x:          -1
		dir:        Direction.none
		positions:  0
		debug_grid: []Direction{len: grid.len * grid[0].len, init: Direction.none}
	}

	for y, line in grid {
		for x, cell in line {
			if cell == `^` {
				guard.y = y
				guard.x = x
				guard.dir = Direction.up
			}
		}
	}
	// Capture initial position
	guard.debug_grid[guard.y * guard.max_x + guard.x] = guard.dir
	guard.positions++

	if guard.in_bounds(guard.y, guard.x) {
		println('Guard ${guard.x},${guard.y} - Direction ${guard.dir}')
	}

	mut steps := 0
	for guard.in_bounds(guard.y, guard.x) {
		steps++
		if steps > guard.max_y * guard.max_x * 3 {
			// Just in case
			break
		}

		v := guard.vector()
		if guard.in_bounds(guard.y + v[0], guard.x + v[1]) {
			next := grid[guard.y + v[0]][guard.x + v[1]]
			if next == `#` {
				guard.dir = guard.dir.next()
				println('bump. change to dir: ${guard.dir}')
			} else {
				guard.y += v[0]
				guard.x += v[1]
				if guard.debug_grid[guard.y * guard.max_x + guard.x] == Direction.none {
					guard.positions++
				}
				guard.debug_grid[guard.y * guard.max_x + guard.x] = guard.dir
			}
		} else {
			break
		}
	}

	println('positions: ${guard.positions}')
	// guard.print()
}

fn (dir Direction) next() Direction {
	match dir {
		.up { return .right }
		.right { return .down }
		.down { return .left }
		.left { return .up }
		.none { return .none }
	}
}

fn (g Agent) in_bounds(y int, x int) bool {
	return y >= 0 && y < g.max_y && x >= 0 && x < g.max_x
}

fn (g Agent) vector() [2]int {
	match g.dir {
		.up { return [-1, 0]! }
		.right { return [0, 1]! }
		.down { return [1, 0]! }
		.left { return [0, -1]! }
		.none { return [0, 0]! }
	}
}

fn (g Agent) print() {
	for y in 0 .. g.max_y {
		for x in 0 .. g.max_x {
			match g.debug_grid[y * g.max_x + x] {
				.up {
					print('^')
				}
				.right {
					print('>')
				}
				.down {
					print('v')
				}
				.left {
					print('<')
				}
				else {
					print('.')
				}
			}
		}
		print('\n')
	}
}

struct Agent {
	max_y int
	max_x int
mut:
	dir        Direction
	y          int
	x          int
	positions  int
	debug_grid []Direction
}
