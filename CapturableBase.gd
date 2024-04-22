extends Area2D

signal base_captured(new_team)

@export var neutral_color = Color(1, 1, 1)
@export var player_color = Color(0.192157, 0.486275, 0.207843)
@export var enemy_color = Color(0.337255, 0.360784, 0.643137)

var player_unit_count:int = 0
var enemy_unit_count:int = 0
var team_to_capture:int = Team.TeamName.NEUTRAL

@onready var team = $Team
@onready var capture_timer = $CaptureTimer
@onready var sprite_2d = $Sprite2D


func _on_body_entered(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count += 1
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count += 1
		
		check_whether_base_can_be_captured()


func _on_body_exited(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count -= 1
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count -= 1


func check_whether_base_can_be_captured():
	var majority_team = get_team_with_majority()
	
	if majority_team == Team.TeamName.NEUTRAL: return
	
	if majority_team == team.team:
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
	base_captured.emit(new_team)
	match new_team:
		Team.TeamName.NEUTRAL:
			sprite_2d.modulate = neutral_color
		Team.TeamName.PLAYER:
			sprite_2d.modulate = player_color
		Team.TeamName.ENEMY:
			sprite_2d.modulate = enemy_color


func _on_capture_timer_timeout():
	set_team(team_to_capture)
