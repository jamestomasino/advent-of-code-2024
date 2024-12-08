import os

fn main() {
	lines := os.read_lines('puzzle.input')!
	ops := ['+', '*', '||']

	mut sum := u64(0)
	for line in lines {
		ns := line.split(' ').map(it.u64())
		mut acc := [ns[1]]
		for n2 in ns[2..] {
			mut nacc := []u64{}
			for n1 in acc {
				for op in ops {
					match op {
						'+' { nacc << n1 + n2 }
						'*' { nacc << n1 * n2 }
						'||' { nacc << '${n1}${n2}'.u64() }
						else {}
					}
				}
			}
			acc = nacc.clone()
		}
		if acc.contains(ns[0]) {
			sum += ns[0]
		}
	}

	println(sum)
}
