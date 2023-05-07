class_name EnemyController
extends Node

signal shot

@export var fall_raycast : RayCast2D
@export var wall_raycast : RayCast2D
@export var aim_raycast : RayCast2D
@export var player_collision_area : Area2D
@export var player_detection_area : Area2D
@export var sprite : Sprite2D
@export var shoots : bool = false
@export var health_system : HealthSystem
@export var damage_on_stomp : bool
@export var damage_on_bullet : bool
@export_range(-1, 1, 1) var initial_direction : int = 1

@onready var shooting : bool = false
@onready var time_since_shoot : float = 0.5
@onready var bullet : PackedScene = preload("res://Scenes/Enemies/enemy_projectile.tscn")
@onready var explosion : PackedScene = preload("res://Scenes/Props/explosion.tscn")

var player : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_collision_area.body_entered.connect(Callable(func(body) -> void:
		if(body.name == "Player"):
			if(damage_on_stomp):
				body.velocity.y = -75
				if(body.global_position.y < get_parent().global_position.y - ((sprite.texture.get_size().y * sprite.scale.y) / 2)):
					health_system.damage(1)
					print(health_system.health)
				else:
					body.get_node("HealthSystem").damage(1)
			else:
				body.velocity.y = -250
				body.get_node("HealthSystem").damage(1)
		))
		
	health_system.damaged.connect(Callable(func(amount) -> void:
		if(health_system.health <= 0):
			get_parent().queue_free()
			var explosion_instance : Sprite2D = explosion.instantiate()
			explosion_instance.global_position = get_parent().global_position
			get_parent().get_parent().add_child(explosion_instance)
		))
		
	if(player_detection_area != null):
		player_detection_area.body_entered.connect(Callable(func(body) -> void:
			print(body.name == "Player")
			if(body.name == "Player"):
				player = body
			))
			
		player_detection_area.body_exited.connect(Callable(func(body) -> void:
			print(body.name == "Player")
			if(body.name == "Player"):
				player = null
			))

func change_direction() -> void:
	get_parent().direction *= -1
	get_parent().scale.x *= -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(fall_raycast.get_collider() == null and get_parent().is_on_floor()):
		change_direction()
		
	if(wall_raycast.get_collider() != null and wall_raycast.get_collider().name != "Player"):
		change_direction()
		
	if(aim_raycast != null):
		if(player != null):
			aim_raycast.target_position = player.global_position - get_parent().global_position
			var collider : Node2D = aim_raycast.get_collider()
			if(collider == null or (collider != null and collider.name == "Player")):
				get_parent().speed = 0.0
				shooting = true
			else:
				get_parent().speed = 120.0
				shooting = false
				
	if(shooting and shoots):
		time_since_shoot -= delta
		if(time_since_shoot <= 0.0):
			time_since_shoot = 2.0
			var bullet_instance : Node2D = bullet.instantiate()
			bullet_instance.global_position = get_parent().global_position
			bullet_instance.direction = get_parent().direction
			get_parent().get_parent().add_child(bullet_instance)
			emit_signal("shot")
