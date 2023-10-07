class_name Letter2D 
extends Node2D


@export_enum("A", "B", "C", "K","O","R") var letter : String



var sprite_dict :={
	"A" : preload("res://Art/2D/A.png"),
	"B" : preload("res://Art/2D/B.png"),
	"C" : preload("res://Art/2D/C.png"),
	"K" : preload("res://Art/2D/K.png"),
	"O" : preload("res://Art/2D/O.png"),
	"R" : preload("res://Art/2D/R.png"),
	
}

func _ready() -> void:
	var area2d = Area2D.new()
	var area_shape = RectangleShape2D.new()
	area_shape.extents = Vector2(32.0, 16.0)
	area2d.shape = area_shape
	
	var collision_shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = Vector2(32.0,16.0)
	collision_shape.shape = rect_shape
	area2d.add_child(collision_shape)
	
	var sprite = Sprite2D.new()
	sprite.texture = sprite_dict[letter]
	area2d.add_child(sprite)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Letra recogida")
