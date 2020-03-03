extends Node2D

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {
	Vector2(0,-1): N
	,Vector2(1, 0): E
	,Vector2(0, 1): S
	,Vector2(-1, 0): W
}

var tile_size = 64
var width = 20
var height = 12

onready var Map = $TileMap

func _ready():
	randomize()
	tile_size = Map.cell_size
	make_maze()

# return list of neighbors that are unvisited
func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func make_maze():
	var unvisited = []
	var stack = []
	
	Map.clear()
	for x in range(width):
		for y in range(height):
			# add every tile as unvisited
			unvisited.append(Vector2(x, y))
			# set every cell location as 15 (solid tile)
			# N|E|S|W is doing a bitwise OR which results in 15 which is all 4 walls
			Map.set_cellv(Vector2(x, y), N|E|S|W)
	var current = Vector2(0, 0)
	unvisited.erase(current)
	
	#recurive backtracking algorithm
	while unvisited:
		# keep running until unvisited list is empty
		
		# get list of nearby neighbors
		var  neighbors = check_neighbors(current, unvisited)
		# check if the neighbors is not empty
		if neighbors.size() > 0:
			# if neighbors is not empty, select a random one
			var next = neighbors[randi() % neighbors.size()]
			
			# place the current cell into stack
			stack.append(current)
			
			# remove walls from both cells
			
			# this gives us the direction of movement
			var dir = next - current
			# produce a current tile that has no wall between current cell and movement cell
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			# produce a movement tile that has no wall between current cell and movement cell
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			# map the values from NESW to cell grids
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			# update the variables to do this again
			current = next
			unvisited.erase(current)
		elif stack:
			# if current neighbors is exhausted, go back to an earlier cell that skim through its unvisited neighbors
			# this is backtracking
			current = stack.pop_back()
		yield(get_tree(), "idle_frame")





