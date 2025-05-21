extends CharacterBody2D


@export var speed: float = 300.0
@export var crouch_speed: float = 150
@export var jump_velocity: float = -400.0
@export var max_jumps: int = 2

var current_speed: float
var last_direction: float
var jumps: int  = 0
var is_look_up: bool = false
var is_crounch: bool = false
var on_floor: bool = true

func _ready() -> void:
	current_speed = speed

func _physics_process(delta: float) -> void:
	on_floor = is_on_floor()
	action_down()
	move_player(delta)
	action_up()
	animate()
	move_and_slide()

func action_down():
	if Input.is_action_pressed("action_down") and on_floor:
		is_crounch = true
		current_speed = crouch_speed
	elif Input.is_action_just_released("action_down"):
		is_crounch = false
		current_speed = speed

func action_up():
	if on_floor and velocity == Vector2(0, 0) and  Input.is_action_just_pressed("action_up") and not is_look_up:
		is_look_up = true
		$CameraAnimation.play("look_up")
	elif (velocity != Vector2(0, 0) or is_crounch) and is_look_up:
		is_look_up = false
		$CameraAnimation.play("reset")

func move_player(delta: float):
	# Add the gravity.
	if not on_floor:
		velocity += get_gravity() * delta
	else:
		jumps = 0

	# Handle jump.
	if Input.is_action_just_pressed("action_jump") and jumps < max_jumps:
		jumps += 1
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("action_left", "action_right")
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

func animate():
	if is_crounch:
		$PlayerAnimation2D.play("crouch")
	elif is_look_up:
		$PlayerAnimation2D.play("look_up")
	elif velocity.x > 0:
		if on_floor:
			$PlayerAnimation2D.play("move_right")
		else:
			$PlayerAnimation2D.play("jump_right")
	elif velocity.x < 0:
		if on_floor:
			$PlayerAnimation2D.play("move_left")
		else:
			$PlayerAnimation2D.play("jump_left")
	elif velocity == Vector2(0, 0):
		if on_floor:
			$PlayerAnimation2D.play("default")
