import os
import regex

fn main() {
	input := os.read_file('puzzle.input')!

	// part 1: grab all the valid mul() blocks, process, sum, output
	query := r'mul\(\d{1,3},\d{1,3}\)'
	mut re_query := regex.regex_opt(query) or { panic(err) }
	matches := re_query.find_all_str(input)
	mut total := 0
	for i in 0 .. matches.len {
		total += mult(matches[i])
	}
	println('total: ${total}')

	/* part 2:
		- find indexes for valid mul() blocks
		- walk through indexes
	*/

	indexes := re_query.find_all(input)
	mut total2 := 0
	for i := 0; i < indexes.len; i += 2 {
		/*
		- check if we're most recently in do or don't
		- if don't, skip
		- else process, sum
		*/
		start := indexes[i]
		end := indexes[i + 1]
		before := input[..start]
		last_do := before.last_index('do()') or { 1 }
		last_dont := before.last_index("don't()") or { 0 }

		if last_dont > last_do {
			continue
		}

		total2 += mult(input[start + 4..end - 1])
	}

	println('total2: ${total2}')
}

fn mult(str string) int {
	splitter := r'\d{1,3}'
	mut re_splitter := regex.regex_opt(splitter) or { panic(err) }
	numbers := re_splitter.find_all_str(str)
	assert numbers.len == 2
	return numbers[0].int() * numbers[1].int()
}
