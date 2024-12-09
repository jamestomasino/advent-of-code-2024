import os

fn main() {
	input := os.read_file('puzzle.input')!

	// build initial data
	mut data := []int{}
	for i := 0; i < input.len; i += 2 {
		block_len := input[i].ascii_str().int()
		for _ in 0 .. block_len {
			data << (i >> 1) // bitshift divide by 2 cheat
		}

		gap_len := input[i + 1].ascii_str().int()
		for _ in 0 .. gap_len {
			data << -1
		}
	}

	// condense
	mut last_swap := data.len // don't loop into the endless -1s
	for i, mut v in data {
		if v != -1 {
			continue
		}
		if i > last_swap {
			break
		}
		for j := data.len - 1; j > i; j-- {
			m := data[j]
			if m == -1 {
				continue
			}
			data[i], data[j] = data[j], data[i]
			last_swap = j
			break
		}
	}

	mut total := 0
	for i in 0 .. last_swap {
		if data[i] == -1 {
			break
		}
		total = total + i * data[i]
		println(data[i])
	}

	println('part 1: ${total}')
}
