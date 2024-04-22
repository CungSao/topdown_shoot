extends Node2D

@onready var player:Player = $Player
@onready var bullets = $BulletManager

func _ready():
	player.connect("player_fired_bullet", bullets.handle_bullet_spawned)
