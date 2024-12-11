import os

struct Val {
	value int
mut:
	check bool
}

enum CheckType {
	null
	even
	other
}

fn main() {
	input := os.read_file('puzzle.input')!
	mut data := input.split(' ').map(mut Val{ value: it.int() })
	for _ in 0 .. 25 {
		data = blink(data, CheckType.null)
		data = blink(data, CheckType.even)
		data = blink(data, CheckType.other)
		data.reset()
	}
	println('items: ${data.len}')
}

fn blink(arr []Val, t CheckType) []Val {
	mut new_arr := []Val{}
	for v in arr {
		new_arr << change(v, t)
	}
	return new_arr
}

fn (mut arr []Val) reset() {
	for mut v in arr {
		v.check = false
	}
}

fn change(i Val, check CheckType) []Val {
	if !i.check {
		match check {
			.null {
				if i.value == 0 {
					return [Val{
						value: 1
						check: true
					}]
				}
			}
			.even {
				len := i.value.str().len
				if len % 2 == 0 {
					return [
						Val{
							value: i.value.str()[0..len / 2].int()
							check: true
						},
						Val{
							value: i.value.str()[len / 2..].int()
							check: true
						},
					]
				}
			}
			.other {
				return [Val{
					value: i.value * 2024
					check: true
				}]
			}
		}
	}
	return [i]
}
