extends Node


signal player_captured_all_bases
signal player_lost_all_bases

var capturable_bases:Array = []


func _ready():
	capturable_bases = get_children()
	for base in capturable_bases:
		base.base_captured.connect(handle_base_captured)


func get_capturable_bases() -> Array:
	return capturable_bases


func handle_base_captured():
	var player_bases = 0
	var enemy_bases = 0
	var total_bases = capturable_bases.size()

	for base in capturable_bases:
		match base.team.team:
			Team.TeamName.PLAYER:
				player_bases += 1
			Team.TeamName.ENEMY:
				enemy_bases += 1
			Team.TeamName.NEUTRAL:
				return
	
	if player_bases == total_bases:
		player_captured_all_bases.emit()
	elif enemy_bases == total_bases:
		player_lost_all_bases.emit()
