extends CharacterBody2D


@export var max_speed : float = 300.0
@export var acceleration : float = 100.0
@export var jump_force : float = -400.0
@export var jump_force_extra_fill : float = 500.0
@export var projectile_energy : int = 5
@export var energy_charge_fill : float = 0.5
@export var max_energy_charge : float = 30.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var jump_force_extra : float = 0.0
@onready var time_charging_jump : float = 0.0
@onready var charging_energy : bool = false
@onready var acceleration_modifier : float = 0.0
@onready var last_direction : float = 0.0
@onready var speed : float = 0.0
@onready var energy_to_regen : float = 0.0
@onready var external_subtracting_energy : bool = false
@onready var projectile : PackedScene = preload("res://Scenes/Player/player_projectile.tscn")

func _input(event: InputEvent) -> void:
	if(Input.is_action_pressed("ui_charge_energy") and is_on_floor()):
		charging_energy = true
	elif(Input.is_action_just_released("ui_charge_energy")):
		charging_energy = false
		
	if(Input.is_action_pressed("ui_shoot")):
		if($StaminaSystem.stamina >= projectile_energy):
			var projectile_instance : CharacterBody2D = projectile.instantiate()
			projectile_instance.position = position
			projectile_instance.direction = last_direction
			get_parent().add_child(projectile_instance)
			$StaminaSystem.subtract_stamina(projectile_energy)
			print($StaminaSystem.stamina)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if(Input.is_action_just_pressed("ui_jump") and is_on_floor()):
		energy_to_regen = 0.0
		velocity.y = jump_force - jump_force_extra
		jump_force_extra = delta * jump_force_extra_fill
		charging_energy = false

	if(charging_energy):
		$ChargingUp.emitting = true
		if($StaminaSystem.stamina > 0 and energy_to_regen < max_energy_charge):
			$StaminaSystem.waste(delta * energy_charge_fill)
			jump_force_extra += delta * jump_force_extra_fill
		else:
			$TotallyCharged.emitting = true
	else:
		$ChargingUp.emitting = false
		$TotallyCharged.emitting = false
		if(!external_subtracting_energy):
			$StaminaSystem.add_stamina(energy_to_regen)
		energy_to_regen = 0.0
		time_charging_jump = 0.0
		jump_force_extra = 0.0

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
#		velocity.x = direction * max_speed * acceleration_modifier
		$AnimationPlayer.play("Walk")
		if(direction >= 0): 
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
			
		last_direction = direction
		speed = move_toward(speed, max_speed * last_direction, acceleration)
	else:
		$AnimationPlayer.play("Idle")
		speed = move_toward(speed, 0.0, acceleration)
		
	velocity.x = speed
	move_and_slide()

func _on_stamina_system_wasted(ammount) -> void:
	energy_to_regen += ammount
