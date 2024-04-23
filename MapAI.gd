extends Node

enum BaseCaptureStartOrder {
	FIRST,
	LAST
}

@export var base_capture_start_order:BaseCaptureStartOrder
@export var team_name:Team.TeamName = Team.TeamName.NEUTRAL
@export var unit:PackedScene
@export var max_units_alive = 4

var target_base:CapturableBase = null
var capturable_bases:Array
var respawn_points:Array
var next_spawn_to_use:int = 0

@onready var team = $Team
@onready var unit_container = $UnitContainer
@onready var respawn_timer = $RespawnTimer


func initialize(_capturable_bases:Array, _respawn_points:Array):
	if _capturable_bases.size() == 0 or _respawn_points.size() == 0 or unit == null:
		push_error("Forgot to properly initialize our Map AI")
		return

	team.team = team_name
	
	respawn_points = _respawn_points
	for respawn in respawn_points:
		spawn_unit(respawn.global_position)
	
	capturable_bases = _capturable_bases
	
	for base in capturable_bases:
		base.base_captured.connect(handle_base_captured)
	
	check_for_next_capturable_base()


func handle_base_captured(_new_team:int):
	check_for_next_capturable_base()


func check_for_next_capturable_base():
	var next_base = get_next_capturable_base()
	if next_base:
		target_base = next_base
		assign_next_capturable_base_to_units(next_base)


func get_next_capturable_base():
	# Assume base capture start order is first
	var list_of_bases = range(capturable_bases.size())
	if base_capture_start_order == BaseCaptureStartOrder.FIRST:
		list_of_bases = range(capturable_bases.size() - 1, -1, -1)
	
	for i in list_of_bases:
		var base:CapturableBase = capturable_bases[i]
		if team.team != base.team.team:
			return base
	return null


func assign_next_capturable_base_to_units(base:CapturableBase):
	for i in unit_container.get_children():
		set_unit_ai_to_advance_to_next_base(i)


func spawn_unit(spawn_location):
	var p_unit:Actor = unit.instantiate()
	unit_container.add_child(p_unit)
	p_unit.global_position = spawn_location
	p_unit.died.connect(handle_unit_death)
	set_unit_ai_to_advance_to_next_base(p_unit)


func set_unit_ai_to_advance_to_next_base(_unit:Actor):
	if target_base:
		var ai:AI = _unit.ai
		ai.next_base = target_base.global_position
		ai.set_state(AI.State.ADVANCE)


func handle_unit_death():
	if respawn_timer.is_stopped() and unit_container.get_children().size() < max_units_alive:
		respawn_timer.start()


func _on_respawn_timer_timeout():
	var respawn:Marker2D = respawn_points[next_spawn_to_use]
	spawn_unit(respawn.global_position)
	next_spawn_to_use += 1
	if next_spawn_to_use == respawn_points.size():
		next_spawn_to_use = 0
	
	if unit_container.get_children().size() < max_units_alive:
		respawn_timer.start()
