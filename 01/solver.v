import os

fn main() {
	input := os.read_file('puzzle.input')!
	lines := input.split_into_lines()

	mut left := []int{}
	mut right := []int{}

	for line in lines {
		parts := line.split('   ')
		left << parts[0].int()
		right << parts[1].int()
	}

	left.sort()
	right.sort()
	assert left.len == right.len

	mut total := 0
	for i in 0 .. left.len {
		mut d := left[i] - right[i]
		if d < 0 {
			d = -d
		}
		total += d
	}

	println('total distance: ${total}')

	mut similarity := 0
	for i in 0 .. left.len {
		occurences := right.filter(it == left[i])
		similarity += left[i] * occurences.len
	}

	println('similarity: ${similarity}')
}
