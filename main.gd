extends Node2D

@onready var player:Player = $Player
@onready var bullets = $BulletManager

func _ready():
	Signals.connect("bullet_fired", bullets.handle_bullet_spawned)
