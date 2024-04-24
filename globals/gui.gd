extends CanvasLayer

@onready var health_bar:ProgressBar = $MarginContainer/Rows/BottomRow/CenterContainer/HealthBar
@onready var current_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/CurrentAmmo
@onready var max_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/MaxAmmo

var player:Player


func set_player(_player:Player):
	player = _player
	
	set_new_health_value(player.health_stat.health)
	set_current_ammo(player.weapon.current_ammo)
	set_max_ammo(player.weapon.max_ammo)
	
	player.player_health_changed.connect(set_new_health_value)
	player.weapon.ammo_changed.connect(set_current_ammo)


func _input(event):
	if event.is_action_released("ui_accept"):
		get_tree().paused = !get_tree().paused


func set_new_health_value(new_health:int):
	var original_color = Color('#5c1c1c')
	var highlight_color = Color('#ff7e7e')
	
	var var_style = health_bar.get("theme_override_styles/fill")
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(var_style, "bg_color", highlight_color, 0.2)
	tween.tween_property(health_bar, "value", new_health, 0.4)
	tween.tween_property(var_style, "bg_color", original_color, 0.2)
	
	
func set_current_ammo(new_ammo:int):
	current_ammo.text = str(new_ammo)
	
	
func set_max_ammo(new_max_ammo:int):
	max_ammo.text = str(new_max_ammo)
