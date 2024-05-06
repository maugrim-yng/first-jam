extends RigidBody2D

@export var speed: float = 300

var velocity=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(velocity * delta)


func set_direction(new_direction: Vector2) -> void:
	# Set the bullet's velocity based on the given direction and speed
	velocity = new_direction.normalized() * speed
