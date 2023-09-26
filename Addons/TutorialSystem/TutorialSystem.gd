class_name TutorialSystem
extends Area2D

@export var tutorial_ui : Control
@export var controls : PackedScene
@export var show_time : float = 8.0
@export var has_buttons : bool = true

func _ready() -> void:
	body_entered.connect(Callable(func(body) -> void:
		if(body.name == "Player"):
			tutorial_ui.show_tutorial(controls, has_buttons, show_time)
			queue_free()
		))
