import os

struct Region {
	id rune
mut:
	area      i64
	perimiter i64
	plots     [][]int
}

fn is_valid_move(row int, col int, max_y int, max_x int) bool {
	return row >= 0 && row < max_y && col >= 0 && col < max_x
}

fn check_cell(mut region &Region, mut visited [][]bool, grid []string, row int, col int, max_y int, max_x int) {
	directions := [[0, 1], [0, -1], [1, 0], [-1, 0]]
	for dir in directions {
		new_row := row + dir[0]
		new_col := col + dir[1]
		// Is the new position on the grid
		if is_valid_move(new_row, new_col, max_y, max_x) {
			// Does new direction match our grid id
			runes := grid[new_row].runes()
			if runes[new_col] == region.id {
				// Have we visited this before
				if !visited[new_row][new_col] {
					// add to region size
					region.area += 1
					region.plots << [new_row, new_col]
					// mark as visited
					visited[new_row][new_col] = true
					// recursive directional search
					check_cell(mut region, mut visited, grid, new_row, new_col, max_y,
						max_x)
				}
			} else {
				// edge detected
				region.perimiter += 1
			}
		} else {
			// grid border, add to perimiter
			region.perimiter += 1
		}
	}
}

fn main() {
	grid := os.read_lines('puzzle.test1.input')!

	max_y := grid.len
	max_x := grid[0].len

	// initialize a 2D array to keep track of grid and visited elements
	mut visited := [][]bool{len: max_y, init: []bool{len: max_x}}

	// transverse grid
	mut regions := []Region{}
	for row in 0 .. max_y {
		for col in 0 .. max_x {
			// if element is unvisited:
			if !visited[row][col] {
				// identify new region and give it an identifier (char value)
				visited[row][col] = true
				runes := grid[row].runes()
				mut region := &Region{
					id:        runes[col]
					area:      1
					perimiter: 0
				}
				region.plots << [row, col]
				// check for each direction to see if 0) valid 1) unvisited and 2) matching id
				check_cell(mut region, mut visited, grid, row, col, max_y, max_x)
				regions << region
			}
		}
	}

	mut price := i64(0)
	for r in regions {
		println('Region: ${r.id} (Area ${r.area}, Perimiter ${r.perimiter})')
		price += r.area * r.perimiter
	}
	println('Region: ${regions[0].id} (${regions[0].plots})')
	println('Total price: ${price}')
}
