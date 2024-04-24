class_name Pathfinding extends Node

# GRID
@export var enabled_color:Color
@export var disabled_color:Color
@export var should_display_grid = false

@onready var grid = $Grid

var grid_rects = {}

# ASTAR
var astar = AStar2D.new()
var tilemap:TileMap
var half_cell_size:Vector2
var used_rect:Rect2


func _physics_process(_delta):
	updated_navigation_map()


func create_navigation_map(_tilemap:TileMap):
	tilemap = _tilemap
	
	half_cell_size = _tilemap.tile_set.tile_size / 2
	used_rect = _tilemap.get_used_rect()
	
	var tiles = _tilemap.get_used_cells(0)

	add_traversable_tiles(tiles)
	connect_traversable_tiles(tiles)


func add_traversable_tiles(tiles:Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		astar.add_point(id, tile)
		
		# Grid
		if should_display_grid:
			var rect = ColorRect.new()
			grid.add_child(rect)
			
			grid_rects[str(id)] = rect
			
			rect.modulate = Color(1,1,1,0.5)
			rect.color = enabled_color
			
			rect.size = tilemap.tile_set.tile_size
			rect.position = tilemap.map_to_local(tile) - half_cell_size


func connect_traversable_tiles(tiles:Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		
		for x in range(3):
			for y in range(3):
				var target = tile + Vector2i(x-1, y-1)
				#var target = tile + Vector2i(point)
				var target_id = get_id_for_point(target)
				
				if tile == target or !astar.has_point(target_id):
					continue
				
				astar.connect_points(id, target_id)


func updated_navigation_map():
	for point in astar.get_point_ids():
		astar.set_point_disabled(point, false)
	
		if should_display_grid:
			grid_rects[str(point)].color = enabled_color

	var obstacles = get_tree().get_nodes_in_group("obstacles")
	
	for obstacle in obstacles:
		if obstacle is TileMap:
			var tiles = obstacle.get_used_cells(0)
			for tile in tiles:
				var id = get_id_for_point(tile)
				if astar.has_point(id):
					astar.set_point_disabled(id)
					if should_display_grid:
						grid_rects[str(id)].color = disabled_color
		if obstacle is CharacterBody2D:
			var tile_coord = tilemap.local_to_map(obstacle.coll_shape.global_position)
			var id = get_id_for_point(tile_coord)
			if astar.has_point(id):
				astar.set_point_disabled(id)
				if should_display_grid:
					grid_rects[str(id)].color = disabled_color


func get_id_for_point(point:Vector2):
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y

	return x + y * used_rect.size.x

# world coordinates
func get_new_path(start:Vector2, end:Vector2):
	var start_tile = tilemap.local_to_map(start)
	var end_tile = tilemap.local_to_map(end)	

	var start_id = get_id_for_point(start_tile)
	var end_id = get_id_for_point(end_tile)

	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return []
	
	var path_map = astar.get_point_path(start_id, end_id)
	
	var path_world = []
	for point in path_map:
		var point_world = tilemap.map_to_local(point)
		path_world.append(point_world)
	
	return path_world
	
