import os

fn main() {
	input := os.read_file('puzzle.input')!
	lines := input.split_into_lines()

	/* part 1: word search for XMAS in all directions
		- split into array of lines/strings
		- find any X as starting point to check for XMAS
			- check for MAS in all of 8 directions, iterate
	*/

	pattern := 'XMAS'

	deltas := [
		[-1, 0]!, // N
		[-1, 1]!, // NE
		[0, 1]!, // E
		[1, 1]!, // SE
		[1, 0]!, // S
		[1, -1]!, // SW
		[0, -1]!, // W
		[-1, -1]!, // NW
	]

	mut total := 0
	mut total2 := 0
	for i, line in lines {
		for j, c in line {
			if c == pattern[0] {
				for d in deltas {
					dy := d[0]
					dx := d[1]
					max_y := i + dy * 3
					max_x := j + dx * 3
					if max_y < 0 || max_y >= lines.len || max_x < 0 || max_x >= line.len {
						// no room to fit match, don't waste time
						continue
					}

					// assume true until not, loop through remaining pattern on delta
					mut success := true
					for m in 1 .. pattern.len {
						ch2 := lines[i + dy * m][j + dx * m]
						if ch2 != pattern[m] {
							success = false
							break
						}
					}
					if success {
						total++
					}
				}
			}

			if c == `A` {
				if j < 1 || i < 1 || j >= line.len - 1 || i >= lines.len - 1 {
					// boundry check first again
					continue
				}

				// ugly brute force
				if ((lines[i - 1][j - 1] == `M` && lines[i + 1][j + 1] == `S`)
					|| (lines[i - 1][j - 1] == `S` && lines[i + 1][j + 1] == `M`))
					&& ((lines[i - 1][j + 1] == `M` && lines[i + 1][j - 1] == `S`)
					|| (lines[i - 1][j + 1] == `S` && lines[i + 1][j - 1] == `M`)) {
					total2++
				}
			}
		}
	}

	println('total xmases: ${total}')
	println('total x-mases: ${total2}')
}
