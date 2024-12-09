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
	mut l := 0
	mut r := data.len - 1
	for {
		for data[l] != -1 {
			l++
		}
		for data[r] == -1 {
			r--
		}
		if l >= r {
			break
		}
		data[l], data[r] = data[r], data[l]
	}

	println(checksum(data))
}

fn checksum(data []int) i64 {
	mut total := i64(0)
	for i, value in data {
		if value != -1 {
			total += value * i
		}
	}
	return total
}
