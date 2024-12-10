import os

fn main() {
	input := os.read_lines('puzzle.input')!

	mut trailheads := []Trail{}
	for y, line in input {
		for x, c in line {
			if c == `0` {
				trailheads << Trail{
					y: y
					x: x
				}
			}
		}
	}

	mut sum := 0
	for t in trailheads {
		s := Step{
			max_y:  input.len
			max_x:  input[0].len
			height: 0
			y:      t.y
			x:      t.x
		}
		sum += s.check(input)
	}

	println('total trailhead score: ${sum}')
}

fn (s Step) vector(dir Direction) [2]int {
	match dir {
		.up { return [-1, 0]! }
		.right { return [0, 1]! }
		.down { return [1, 0]! }
		.left { return [0, -1]! }
	}
}

fn (s Step) in_bounds(y int, x int) bool {
	return y >= 0 && y < s.max_y && x >= 0 && x < s.max_x
}

fn (s Step) check(input []string) int {
	mut sum := 0
	for dir in [Direction.up, Direction.right, Direction.down, Direction.left] {
		mut v := s.vector(dir)
		if s.in_bounds(s.y + v[0], s.x + v[1]) {
			val := input[s.y + v[0]][s.x + v[1]].ascii_str().int()
			if val == s.height + 1 {
				if s.height == 8 {
					sum += 1
				} else {
					new_s := Step{
						max_y:  s.max_y
						max_x:  s.max_x
						height: s.height + 1
						y:      s.y + v[0]
						x:      s.x + v[1]
					}
					sum += new_s.check(input)
				}
			}
		}
	}
	return sum
}

struct Trail {
	y    int
	x    int
	size int
}

struct Step {
	max_y int
	max_x int
mut:
	y      int
	x      int
	height int
	valid  bool
}

enum Direction {
	up
	right
	down
	left
}
