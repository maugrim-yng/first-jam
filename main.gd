extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	%Player.global_position=%PlayerStartPosition.global_position
	if %Player.fly:
		%fly.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_death_zone_area_entered(area):
	%Player.global_position=%PlayerStartPosition.global_position
