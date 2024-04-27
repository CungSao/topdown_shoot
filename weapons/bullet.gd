class_name Bullet extends Area2D

@export var speed = 300
var direction:Vector2
var team:int = -1


func _physics_process(delta):
	var velocity = direction * speed * delta
	
	global_position += velocity


func set_direction(_direction:Vector2):
	direction = _direction
	rotation += direction.angle()


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.has_method("handle_hit"):
		if body.has_method("get_team") and body.get_team() != team:
			body.handle_hit()
	queue_free()
