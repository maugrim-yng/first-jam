extends CharacterBody2D

var SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var character_body_2d = %Player

var jump = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 800

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump = jump + 1
		else:
			if jump > 0:
				velocity.y = JUMP_VELOCITY * 0.75
				jump = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Check for collision with Area2D nodes
	var platform = get_last_slide_collision()
	if platform != null:
		if platform.get_collider().has_method("get_bounce"):
			var bounce = platform.get_collider().get_bounce()
		# Adjust the player's velocity based on the bounce value.
			velocity.y = -bounce

func _on_area_2d_body_entered(body):
	if body.has_method("get_bounce"):
		var bounce = body.get_bounce()
		if bounce != 0:
		# Adjust the player's velocity based on the bounce value.
			velocity.y = bounce


func _on_death_zone_area_entered(area):
	reset_level()

func reset_level():
	pass
