class_name EnemyController
extends Node

@export var fall_raycast : RayCast2D
@export var wall_raycast : RayCast2D
@export var shoots : bool = false
@export var damage_on_stomp : bool
@export var damage_on_bullet : bool
@export var health_system : HealthSystem
@export_range(-1, 1, 1) var initial_direction : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func change_direction() -> void:
	get_parent().direction *= -1
	get_parent().scale.x *= -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(fall_raycast.get_collider() == null and get_parent().is_on_floor()):
		change_direction()
		
	if(wall_raycast.get_collider() != null and wall_raycast.get_collider().name != "Player"):
		change_direction()
		
