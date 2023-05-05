extends CharacterBody2D


@export var max_speed : float = 300.0
@export var jump_force : float = -400.0
@export var jump_force_extra_fill : float = 500.0
@export var minimum_charge_time : float = 0.75
@export var acceleration : float = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var jump_force_extra : float = 0.0
@onready var time_charging_jump : float = 0.0
@onready var charging_energy : bool = false
@onready var acceleration_modifier : float = 0.0
@onready var last_direction : float = 0.0
@onready var speed : float = 0.0
@onready var energy_to_regen : float = 0.0

func _input(event: InputEvent) -> void:
	if(Input.is_action_pressed("ui_charge_energy") and is_on_floor()):
		charging_energy = true
	elif(Input.is_action_just_released("ui_charge_energy")):
		charging_energy = false

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
		$StaminaSystem.waste(delta)
		time_charging_jump += delta
		if(time_charging_jump >= minimum_charge_time):
			jump_force_extra += delta * jump_force_extra_fill
	else:
		$StaminaSystem.add_stamina(energy_to_regen)
		energy_to_regen = 0.0
		time_charging_jump = 0.0
		jump_force_extra = 0.0
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
