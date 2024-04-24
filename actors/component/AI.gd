class_name AI extends Node2D

signal state_changed(new_state)

enum State{
	PATROL,
	ENGAGE,
	ADVANCE,
}

@onready var patrol_timer = $PatrolTimer

var current_state:int = -1 : set = set_state
var actor:Actor = null
var target:CharacterBody2D = null
var weapon:Weapon = null
var team:int = -1

# PATROL STATE
var origin:Vector2
var patrol_location:Vector2
var patrol_location_reached = false
var actor_velocity:Vector2

# ADVANCE STATE
var next_base:Vector2

var pathfinding:Pathfinding


func _ready():
	set_state(State.PATROL)


func _physics_process(_delta):
	match current_state:
		State.PATROL:
			if !patrol_location_reached:
				var path = pathfinding.get_new_path(global_position, patrol_location)
				if path.size() > 1:
					actor_velocity = actor.velocity_toward(path[1])
					actor.velocity = actor_velocity
					actor.move_and_slide()
					actor.rotate_toward(path[1])
				else:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if target != null and weapon != null:
				actor.rotate_toward(target.global_position)
				var angle_to_target = actor.global_position.direction_to(target.global_position).angle()
				if abs(actor.rotation - angle_to_target) < 0.1:
					weapon.shoot()
			else:
				print("In the engage state but no weapon/target")
		State.ADVANCE:
			var path = pathfinding.get_new_path(global_position, next_base)
			if path.size() > 1:
				actor_velocity = actor.velocity_toward(path[1])
				actor.velocity = actor_velocity
				actor.move_and_slide()
				actor.rotate_toward(path[1])
			else:
				set_state(State.PATROL)
		_:
			print("Error: found a state for our enemy that should not exist")


func initialize(_actor, _weapon:Weapon, _team:int):
	actor = _actor
	weapon = _weapon
	team = _team

	weapon.weapon_out_of_ammo.connect(handle_reload)


func set_state(new_state):
	if new_state == current_state: return
	
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	
	elif new_state == State.ADVANCE:
		if actor.has_reached_position(next_base):
			set_state(State.PATROL)
				
	current_state = new_state
	state_changed.emit(current_state)


func handle_reload():
	weapon.start_reload()


func _on_patrol_timer_timeout():
	var patrol_range = 150
	var rand_x = randi_range(-patrol_range, patrol_range)
	var rand_y = randi_range(-patrol_range, patrol_range)
	patrol_location = Vector2(rand_x, rand_y) + origin
	patrol_location_reached = false


func _on_detection_zone_body_entered(body):
	if body.has_method("get_team") and body.get_team() != team:
		set_state(State.ENGAGE)
		target = body


func _on_detection_zone_body_exited(body):
	if body == target:
		set_state(State.ADVANCE)
		target = null
