extends Node2D

const PLAYER = preload("res://actors/object/player.tscn")

@onready var s_capturable_base = $SCapturableBase
@onready var enemy_map_ai = $EnemyMapAI
@onready var ally_map_ai = $AllyMapAI
@onready var bullets = $SBullet
@onready var camera_2d = $Camera2D
@onready var gui = $GUI


func _ready():
	randomize()
	Signals.connect("bullet_fired", bullets.handle_bullet_spawned)

	var ally_respawns = $AllyRespawnPoints
	var enemy_respawns = $EnemyRespawnPoints
	
	var bases = s_capturable_base.get_capturable_bases()
	ally_map_ai.initialize(bases, ally_respawns.get_children())
	enemy_map_ai.initialize(bases, enemy_respawns.get_children())

	spawn_player()


func spawn_player():
	var player = PLAYER.instantiate()
	add_child(player)
	player.set_camera_transform(camera_2d.get_path())
	player.died.connect(spawn_player)
	
	gui.set_player(player)
