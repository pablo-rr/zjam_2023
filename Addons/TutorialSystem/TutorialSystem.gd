class_name TutorialSystem
extends Area2D

@export var tutorial_ui : Control
@export_multiline var tutorial_text : String
@export var show_time : float

func _ready() -> void:
	body_entered.connect(Callable(func(body) -> void:
		if(body.name == "Player"):
			tutorial_ui.tutorial_text(tutorial_text, show_time)
			queue_free()
		))
