class_name CapturableBase extends Area2D

signal base_captured()

@export var neutral_color = Color(1, 1, 1)
@export var player_color = Color(0.192157, 0.486275, 0.207843)
@export var enemy_color = Color(0.337255, 0.360784, 0.643137)

var player_unit_count:int = 0
var enemy_unit_count:int = 0
var team_to_capture:int = Team.TeamName.NEUTRAL

@onready var coll = $CollisionShape2D
@onready var team = $Team
@onready var capture_timer = $CaptureTimer
@onready var sprite_2d = $Sprite2D

@onready var player_label = $Player
@onready var enemy_label = $Enemy


func _ready():
	player_label.text = "0"
	enemy_label.text = "0"
	

func get_rand_pos_within_capture_radius() -> Vector2:
	var extents = coll.shape.extents
	var top_left = coll.global_position - (extents / 2)
	
	var x = randf_range(top_left.x, top_left.x + extents.x)
	var y = randf_range(top_left.y, top_left.y + extents.y)
	
	return Vector2(x, y)


func _on_body_entered(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count += 1
			change_enemy_label()
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count += 1
			change_player_label()
		
		check_whether_base_can_be_captured()


func _on_body_exited(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count -= 1
			change_enemy_label()
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count -= 1
			change_player_label()
		
		check_whether_base_can_be_captured()


func change_player_label():
	player_label.text = str(player_unit_count)
	
	
func change_enemy_label():
	enemy_label.text = str(enemy_unit_count)


func check_whether_base_can_be_captured():
	var majority_team = get_team_with_majority()

	if majority_team == Team.TeamName.NEUTRAL:
		print("Teams evened out, stopping capture clock")
		team_to_capture = Team.TeamName.NEUTRAL
		capture_timer.stop()
	elif majority_team == team.team:
		print("Owning team regained majority, stopping capture clock")
		team_to_capture = Team.TeamName.NEUTRAL
		capture_timer.stop()
	else:
		print("New team has majority in base, starting capture clock")
		team_to_capture = majority_team
		capture_timer.start()


func get_team_with_majority() -> int:
	if enemy_unit_count == player_unit_count:
		return Team.TeamName.NEUTRAL
	elif enemy_unit_count > player_unit_count:
		return Team.TeamName.ENEMY
	else:
		return Team.TeamName.PLAYER


func set_team(new_team:int):
	team.team = new_team
	base_captured.emit()
	match new_team:
		Team.TeamName.NEUTRAL:
			sprite_2d.modulate = neutral_color
		Team.TeamName.PLAYER:
			sprite_2d.modulate = player_color
		Team.TeamName.ENEMY:
			sprite_2d.modulate = enemy_color


func _on_capture_timer_timeout():
	set_team(team_to_capture)
