extends CharacterBody2D


@export var max_speed : float = 300.0
@export var acceleration : float = 100.0
@export var jump_force : float = -400.0
@export var jump_force_extra_fill : float = 500.0
@export var projectile_energy : int = 5
@export var energy_charge_fill : float = 0.5
@export var max_energy_charge : float = 30.0
@export var max_power_up_time : float = 10.0
@export var death_screem : Control
@export var power_up_ui : Control

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var jump_force_extra : float = 0.0
@onready var time_charging_jump : float = 0.0
@onready var charging_energy : bool = false
@onready var acceleration_modifier : float = 0.0
@onready var last_direction : float = 1.0
@onready var speed : float = 0.0
@onready var energy_to_regen : float = 0.0
@onready var external_subtracting_energy : bool = false
@onready var projectile : PackedScene = preload("res://Scenes/Player/player_projectile.tscn")
@onready var projectile_charged : PackedScene = preload("res://Scenes/Player/player_projectile_charged.tscn")
@onready var infinite_energy : bool = true
@onready var power_up_time : float = 0.0
@onready var energy_to_super_shoot : float = 12.0
@onready var explosion : PackedScene = preload("res://Scenes/Props/explosion.tscn")

func _ready() -> void:
	$MusicNormal.play(0.0)
	$MusicPowerUp.play(0.0)
	if(CheckpointSystem.checkpoint != Vector2.ZERO):
		print("hehe")
		global_position = CheckpointSystem.checkpoint
	else:
		$StaminaSystem.subtract_stamina(40)

func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("ui_charge_energy") and is_on_floor()):
		charging_energy = true
		$ChargingEnergy.play(0.0)
	elif(Input.is_action_just_released("ui_charge_energy")):
		$ChargingEnergy.stop()
		charging_energy = false
		
	if(Input.is_action_pressed("ui_shoot")):
		if($StaminaSystem.stamina >= projectile_energy):
			if(energy_to_regen < energy_to_super_shoot):
				$SuperShoot.emitting = false
				$Shoot.play(0.0)
				var projectile_instance : CharacterBody2D = projectile.instantiate()
				projectile_instance.position = position
				projectile_instance.position.y += 4.0
				projectile_instance.direction = last_direction
				get_parent().add_child(projectile_instance)
				if(!infinite_energy):
					$StaminaSystem.subtract_stamina(projectile_energy)
			else:
				$SuperShoot.emitting = true
				energy_to_regen = 0.0
				$Shoot.play(0.0)
				var projectile_instance : CharacterBody2D = projectile_charged.instantiate()
				projectile_instance.position = position
				projectile_instance.direction = last_direction
				get_parent().add_child(projectile_instance)
				if(!infinite_energy):
					$StaminaSystem.subtract_stamina(projectile_energy)
					

func _physics_process(delta: float) -> void:
	power_up_time -= delta
	if(power_up_time > 0.0):
		infinite_energy = true
	else:
		infinite_energy = false

	if(energy_to_regen < energy_to_super_shoot):
		$SuperShoot.emitting = false
		$ChargingUp.emitting = true
	else:
		$SuperShoot.emitting = true
		$ChargingUp.emitting = false
		
	if(energy_to_regen < 0.0):
		$ChargingEnergy.stop()
		
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if(infinite_energy):
		energy_charge_fill = 1.0
		power_up_ui.material.set_shader_parameter("strength", 1)
		$Sprite2D.material.set_shader_parameter("strength", move_toward($Sprite2D.material.get_shader_parameter("strength"), 0.46, 0.5))
		$MusicNormal.volume_db = lerp($MusicNormal.volume_db, -80.0, 0.09)
		$MusicPowerUp.volume_db = lerp($MusicPowerUp.volume_db, 0.0, 0.09)
	else:
		power_up_ui.material.set_shader_parameter("strength", 0)
		energy_charge_fill = 0.5
		$Sprite2D.material.set_shader_parameter("strength", move_toward($Sprite2D.material.get_shader_parameter("strength"), 0.0, 0.5))
		$MusicNormal.volume_db = lerp($MusicNormal.volume_db, 0.0, 0.09)
		$MusicPowerUp.volume_db = lerp($MusicPowerUp.volume_db, -80.0, 0.09)

	if(Input.is_action_just_pressed("ui_jump") and is_on_floor()):
		$Jump.play(0.0)
		energy_to_regen = 0.0
		velocity.y = jump_force - jump_force_extra
		jump_force_extra = delta * jump_force_extra_fill
		charging_energy = false
		$ChargingEnergy.stop()

	if(charging_energy):
		if(energy_to_regen < energy_to_super_shoot):
			$ChargingUp.emitting = true
		if($StaminaSystem.stamina > 0 and energy_to_regen < max_energy_charge):
			if(!infinite_energy):
				$StaminaSystem.waste(delta * energy_charge_fill)
			jump_force_extra += delta * jump_force_extra_fill
		else:
			$ChargingEnergy.pitch_scale = 1.5
			$TotallyCharged.emitting = true
	else:
		$ChargingEnergy.pitch_scale = 1.0
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


func _on_health_system_damaged(ammount) -> void:
	$ReceiveDamage.play(0.0)
	if($HealthSystem.health <= 0.0):
		print("lol")
		$Sprite2D.modulate = Color(0,0,0,0)
		$CollisionShape2D.disabled = true
		$ChargingUp.visible = false
		$TotallyCharged.visible = false
		$SuperShoot.visible = false
		$Sprite2D.visible = false
		var explosion_instance : Sprite2D = explosion.instantiate()
		explosion_instance.global_position = global_position
		get_parent().add_child(explosion_instance)
		set_process(false)
		set_physics_process(false)
		death_screem.death_scene()


func _on_health_system_fatally_damaged() -> void:
	print("he muerto")
	
