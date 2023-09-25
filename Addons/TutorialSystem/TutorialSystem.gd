class_name TutorialSystem
extends Area2D

@export var tutorial_ui : Control
@export var controls : PackedScene
@export var controls_android : PackedScene
@export_multiline var tutorial_text : String
@export_multiline var tutorial_text_android : String
@export var show_time : float

func _ready() -> void:
	body_entered.connect(Callable(func(body) -> void:
		if(body.name == "Player"):
			if(OS.get_name() == "Android"):
				tutorial_ui.tutorial_text(tutorial_text_android, show_time)
			else:
				tutorial_ui.tutorial_text(tutorial_text, show_time)
			queue_free()
		))
