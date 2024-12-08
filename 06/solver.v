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
		max_y: grid.len
		max_x: grid[0].len
		y:     -1
		x:     -1
		dir:   Direction.none
		moves: 0
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
				guard.dir = next_dir(guard.dir)
				println('bump. change to dir: ${guard.dir}')
			} else {
				guard.y += v[0]
				guard.x += v[1]
				guard.moves++
			}
		} else {
			break
		}
	}

	println('Moves: ${guard.moves}')
}

fn next_dir(dir Direction) Direction {
	return unsafe { Direction((int(dir) + 1) % 4) }
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

struct Agent {
	max_y int
	max_x int
mut:
	dir   Direction
	y     int
	x     int
	moves int
}
