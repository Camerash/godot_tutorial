extends Area2D

# Singal emitted when got hit
signal hit

export var speed = 400 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window

func _ready():
	screen_size = get_viewport_rect().size
	# Hide player when ready
	hide()
	
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	# Is player moving?
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	# Clamping player position
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)	
	position.y = clamp(position.y, 0, screen_size.y)
	# Animation tweaking base on movement
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false # Reset
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit
	emit_signal("hit")
	# Disable player collider to prevent triggering hit signal again
	# Do it in a safe time so use set_deferred
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
