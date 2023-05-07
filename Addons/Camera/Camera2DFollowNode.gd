class_name Camera2DFollowNode
extends Camera2D

@export var target : Node2D
@export var speed : float = 0.09

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position, target.position, speed)
	if(target.infinite_energy):
		$AnimationPlayer.play("Shake")
	else:
		$AnimationPlayer.play("RESET")
