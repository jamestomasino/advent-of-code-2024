import os
import regex

fn main() {
	input := os.read_file('puzzle.input')!
	query := r'mul\(\d{1,3},\d{1,3}\)'
	mut re_query := regex.regex_opt(query) or { panic(err) }
	// println(re_query.get_query())
	matches := re_query.find_all_str(input)
	// println(matches)
	mut total := 0
	for i in 0 .. matches.len {
		total += mult(matches[i])
	}
	println('total: ${total}')
}

fn mult(str string) int {
	splitter := r'\d{1,3}'
	mut re_splitter := regex.regex_opt(splitter) or { panic(err) }
	numbers := re_splitter.find_all_str(str)
	assert numbers.len == 2
	return numbers[0].int() * numbers[1].int()
}
