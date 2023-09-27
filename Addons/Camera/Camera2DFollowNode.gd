class_name Camera2DFollowNode
extends Camera2D

@export var target : Node2D
@export var speed : float = 0.09
@export var max_movement_offset : float = 35.0

var movement_offset : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = target.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var offset_position = target.position
	offset_position.x += movement_offset
	
	position = lerp(position, offset_position, speed)
	if(target.infinite_energy):
		$AnimationPlayer.play("Shake")
	else:
		$AnimationPlayer.play("RESET")
		
	if(target.speed > 0):
		movement_offset = move_toward(movement_offset, max_movement_offset, 5)
	elif(target.speed < 0):
		movement_offset = move_toward(movement_offset, -max_movement_offset, 5)
#	else:
#		movement_offset = lerp(movement_offset, 0.0, 0.06)
