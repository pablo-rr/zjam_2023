extends Control
class_name UIFocusedAnimator

@export var scale_animation : float = 0.75
@export var animation_speed : float = 0.35

@onready var ui : Control = get_parent()

func animate() -> void:
	var tween_shrink : Tween = get_tree().create_tween()
	tween_shrink.finished.connect(Callable(func() -> void:
		var tween_grow : Tween = get_tree().create_tween()
		tween_grow.finished.connect(Callable(func() -> void:
			if(ui.has_focus()):
				animate()
		))
		tween_grow.tween_property(ui, "scale", Vector2(1, 1), animation_speed)
	))
	
	tween_shrink.tween_property(ui, "scale", Vector2(scale_animation, scale_animation), animation_speed)

func _ready() -> void:
	ui.pivot_offset = ui.size / 2
	
	ui.focus_entered.connect(Callable(func() -> void:
		animate()
	))
	
	ui.focus_exited.connect(Callable(func() -> void:
		if(get_tree() != null):
			var tween_grow : Tween = get_tree().create_tween()
			tween_grow.finished.connect(Callable(func() -> void:
				if(ui.has_focus()):
					animate()
			))
	))
