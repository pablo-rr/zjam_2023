class_name CheckpointArea
extends Area2D

@export var checkpoint : Node2D

func _ready() -> void:
	body_entered.connect(Callable(func(body) -> void:
		if(body.name == "Player"):
			CheckpointSystem.checkpoint = checkpoint.global_position
			print("CHK: ", checkpoint)
		))

