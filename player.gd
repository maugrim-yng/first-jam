extends CharacterBody2D

var SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var character_body_2d = %Player

var jump = 0
var fly = true
var double_jump = false

const fireball=preload("res://fireball.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 800

func _ready():
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			# Left mouse button clicked
			print("Left mouse button clicked")
			shootTowards(get_local_mouse_position())
			
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta	
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_up"):
		
		if fly:
			velocity.y = JUMP_VELOCITY
			if not is_on_floor():
				var dupe = duplicateNode(%jump_particles)
				dupe.emitting=true
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump = jump + 1
		else:
			if double_jump:
				if jump > 0:
					var dupe = duplicateNode(%jump_particles)
					dupe.emitting=true
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
	print(body.name)
	if body.has_method("get_bounce"):
		var bounce = body.get_bounce()
		if bounce != 0:
		# Adjust the player's velocity based on the bounce value.
			velocity.y = bounce


func _on_death_zone_area_entered(area):
	reset_level()

func reset_level():
	pass


func _on_colission_area_entered(area):
	print(area.name)
	if area.has_method("get_bounce"):
		var bounce = area.get_bounce()
		if bounce != 0:
		# Adjust the player's velocity based on the bounce value.
			velocity.y = -bounce

func duplicateNode(original_node: Node) -> Node:
	# Create a new instance of the original node
	var duplicate = original_node.duplicate()

	# Add the duplicate as a child of the original node's parent
	if original_node.get_parent():
		original_node.get_parent().add_child(duplicate)

	# Optionally, you can set the transform and properties of the duplicate node here
	duplicate.set_name(original_node.get_name() + "_duplicate")
	duplicate.set_position(original_node.get_position() + Vector2(20, 20))  # Example offset

	# Return the duplicate node
	return duplicate


func shootTowards(target_position: Vector2) -> void:
	# Create a new bullet node
	var bullet = fireball.instantiate()
	# Add the bullet to the scene
	add_child(bullet)

	# Set the bullet's position to the player's position
	bullet.global_position = global_position

	# Calculate direction towards target position
	var direction = (target_position - global_position).normalized()

	# Set the bullet's direction
	bullet.set_direction(direction)
