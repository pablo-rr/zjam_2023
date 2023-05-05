extends CharacterBody2D


@export var speed : float = 300.0
@export var jump_force : float = -400.0
@export var jump_force_extra_fill : float = 500.0
@export var minimum_charge_time : float = 0.75

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var jump_force_extra : float = 0.0
@onready var time_charging_jump : float = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	
	print("time_charging_jump", str(time_charging_jump))
	print("jump_force_extra", str(jump_force_extra))
	
	if(Input.is_action_pressed("ui_jump")):
		time_charging_jump += delta
		if(time_charging_jump >= minimum_charge_time):
			jump_force_extra += delta * jump_force_extra_fill
	elif(Input.is_action_just_released("ui_jump") and is_on_floor()):
		velocity.y = jump_force - jump_force_extra
		time_charging_jump = 0.0
		jump_force_extra = delta * jump_force_extra_fill
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
