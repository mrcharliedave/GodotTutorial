extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	pass


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func pause():
	$AnimatedSprite2D.stop()
	linear_velocity = Vector2.ZERO
	angular_velocity = PI
