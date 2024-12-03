import os

fn main() {
	input := os.read_file('puzzle.input')!
	lines := input.split_into_lines()

	mut total := 0
	mut dampener := 0
	for line in lines {
		report := line.split(' ').map(it.int())
		// check safety of each line
		if is_safe(report) {
			// if safe, iterate total
			total++
		} else {
			// try again, but delete each level in report to see if any pass
			for i in 0 .. report.len {
				mut clone := report.clone()
				clone.delete(i)
				if is_safe(clone) {
					dampener++
					break
				}
			}
		}
	}

	dampener += total

	println('total safe reports: ${total}')
	println('problem dampener safe reports: ${dampener}')
}

fn is_safe(report []int) bool {
	// determine order of report levels
	desc := report[0] > report[1]
	for i in 1 .. report.len {
		// check that all levels follow same order
		prev := report[i - 1]
		current := report[i]
		if (prev > current) != desc {
			return false
		}

		// check that distance is never > 2
		delta := prev - current
		if delta == 0 || delta > 3 || delta < -3 {
			return false
		}
	}
	return true
}
