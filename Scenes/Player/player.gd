extends CharacterBody2D
class_name Player

@export var speed: float = 300.0
@export var run_speed: float = 700.0
@export var crouch_speed: float = 150
@export var jump_velocity: float = -400.0
@export var max_jumps: int = 2
@export var dodge_time: float = 0.3
@export var dodge_cooldown: float = 1.0
@export var limit_camera_tilemap: TileMapLayer

var current_speed: float
var last_direction: float
var jumps: int  = 0
var is_look_up: bool = false
var is_crounch: bool = false
var is_dodge: bool = false
var on_floor: bool = true
var current_weapon: Weapon
var quick_weapons: Array[Weapon]
var selected_weapon: int = 0

func _ready() -> void:
	current_speed = speed
	init_weapon()

func _physics_process(delta: float) -> void:
	on_floor = is_on_floor()
	if PlayerManager.amount_enemies_in_room <= 0:
		current_speed = run_speed
	if not is_dodge:
		action_attack()
		if not current_weapon.is_attacking:
			action_dodge()
			action_down()
			move_player(delta)
			action_up()
			action_switch()
		
	animate()
	move_and_slide()

func action_switch():
	if Input.is_action_just_pressed("action_switch"):
		selected_weapon += 1
		if selected_weapon >= quick_weapons.size():
			selected_weapon = 0
		remove_child(current_weapon)
		current_weapon = quick_weapons[selected_weapon]
		add_child(current_weapon)

func action_attack():
	if Input.is_action_just_pressed("action_attack"):
		current_weapon.main_action()
		velocity = Vector2(0, 0)

func action_dodge():
	if Input.is_action_just_pressed("action_dodge") and not is_dodge and $DodgeCooldown.is_stopped():
		is_dodge = true
		velocity.x = 0
		$DodgeTimer.start(dodge_time)
		$HitBoxArea.monitoring = false
		$HitBoxArea.visible = false

func action_down():
	if Input.is_action_pressed("action_down") and on_floor:
		is_crounch = true
		current_speed = crouch_speed
		if $CrounchDownPlataformTimer.is_stopped():
			$CrounchDownPlataformTimer.start()
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
		current_weapon.set_direction(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

func animate():
	if is_dodge:
		$PlayerAnimation2D.play("dodge")
	elif is_crounch:
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

func init_weapon():
	for weapon_resource in PlayerManager.player_weapon_resource:
		quick_weapons.append(weapon_resource.instantiate())
	current_weapon = quick_weapons[selected_weapon]
	add_child(current_weapon)


func _on_dodge_timer_timeout() -> void:
	is_dodge = false
	$HitBoxArea.monitoring = true
	$HitBoxArea.visible = true
	$DodgeCooldown.start(dodge_cooldown)


func _on_crounch_down_plataform_timer_timeout() -> void:
	if is_crounch:
		set_collision_mask_value(7, false)
		await get_tree().create_timer(0.2).timeout
		set_collision_mask_value(7, true)
