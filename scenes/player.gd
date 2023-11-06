extends Area2D
signal hit

@export var speed = 400
var screenSize

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screenSize = get_viewport_rect().size

# Called when the game starts
func start(pos):
	$CollisionShape2D.disabled = false
	position = pos
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var inputVelocity = _processMovementInput().normalized()
	var updatedMovementVelocity = inputVelocity * speed
	if(updatedMovementVelocity.length() > 0):
		position += updatedMovementVelocity * delta
		position = position.clamp(Vector2.ZERO, screenSize)
	_updatePlayerAnimation(inputVelocity)

# Handles code for updating player movement based on input values
func _processMovementInput():
	var velocity = Vector2.ZERO
	if(_isInputPressed("move_right")):
		velocity.x += 1
	if(_isInputPressed("move_left")):
		velocity.x -= 1
	if(_isInputPressed("move_up")):
		velocity.y -= 1
	if(_isInputPressed("move_down")):
		velocity.y += 1
	return velocity

# Helper function for fetching input state
func _isInputPressed(input):
	return Input.is_action_pressed(input)

# Handles the players movement animation
func _updatePlayerAnimation(velocity):
	if(velocity.length() > 0):
		if(velocity.x != 0):
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.animation = "up"
			$AnimatedSprite2D.flip_v = velocity.y > 0
			$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

# Handles player collision
func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
