extends Node2D

const PLAYER = preload("res://actors/object/player.tscn")
const GAME_OVER_SCREEN = preload("res://UI/game_over_screen.tscn")
const PAUSE_SCREEN = preload("res://UI/pause_screen.tscn")

@onready var s_capturable_base = $SCapturableBase
@onready var enemy_map_ai = $EnemyMapAI
@onready var ally_map_ai = $AllyMapAI
@onready var bullets = $SBullet
@onready var camera_2d = $Camera2D
@onready var gui = $GUI
@onready var ground = $Ground
@onready var pathfinding = $Pathfinding


func _ready():
	randomize()
	Signals.connect("bullet_fired", bullets.handle_bullet_spawned)

	var ally_respawns = $AllyRespawnPoints
	var enemy_respawns = $EnemyRespawnPoints
	
	pathfinding.create_navigation_map(ground)

	var bases = s_capturable_base.get_capturable_bases()
	ally_map_ai.initialize(bases, ally_respawns.get_children(), pathfinding)
	enemy_map_ai.initialize(bases, enemy_respawns.get_children(), pathfinding)
	s_capturable_base.player_captured_all_bases.connect(handle_player_win)
	s_capturable_base.player_lost_all_bases.connect(handle_player_lost)
	
	spawn_player()


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = PAUSE_SCREEN.instantiate()
		add_child(pause_menu)


func spawn_player():
	var player = PLAYER.instantiate()
	add_child(player)
	player.set_camera_transform(camera_2d.get_path())
	player.died.connect(spawn_player)
	
	gui.set_player(player)


func handle_player_win():
	var game_over = GAME_OVER_SCREEN.instantiate()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true
	

func handle_player_lost():
	var game_over = GAME_OVER_SCREEN.instantiate()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true
