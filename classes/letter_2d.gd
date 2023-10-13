class_name Letter2D 
extends Node2D

@export_enum("R", "O", "B", "C", "A", "K") var letter : String = "R"

var sprite_dict :={
	"R" : preload("res://Art/2D/R.png"),
	"O" : preload("res://Art/2D/O.png"),
	"B" : preload("res://Art/2D/B.png"),
	"C" : preload("res://Art/2D/C.png"),
	"A" : preload("res://Art/2D/A.png"),
	"K" : preload("res://Art/2D/K.png"),
}

func _ready() -> void:
	var sprite : Sprite2D = Sprite2D.new()
	sprite.texture = sprite_dict[letter]
	add_child(sprite)
	
	var area_2d : Area2D = Area2D.new()
	add_child(area_2d)
	
	var coll : CollisionShape2D = CollisionShape2D.new()
	coll_shape.shape = Shape2D.new()
	area_2d.add_child(coll_shape)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Letra recogida")
