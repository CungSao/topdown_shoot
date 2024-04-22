extends Node2D

@onready var s_capturable_base = $SCapturableBase
@onready var enemy_map_ai = $EnemyMapAI
@onready var ally_map_ai = $AllyMapAI
@onready var bullets = $SBullet
@onready var player:Player = $Player

func _ready():
	randomize()
	Signals.connect("bullet_fired", bullets.handle_bullet_spawned)

	var bases = s_capturable_base.get_capturable_bases()
	ally_map_ai.initialize(bases)
	enemy_map_ai.initialize(bases)
