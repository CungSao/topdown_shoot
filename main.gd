extends Node2D

@onready var player = $Player
@onready var bullets = $BulletManager

func _ready():
	player.connect("fired_bullet", bullets.handle_bullet_spawned)
