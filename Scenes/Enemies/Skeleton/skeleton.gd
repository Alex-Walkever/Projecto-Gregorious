extends Enemy

var target: Node2D

func _physics_process(delta: float) -> void:
	if hit_points <= 0:
		return
	
	chase_target(delta)
	animate_enemy()
	move_and_slide()

func chase_target(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if target:
		var distance_to_player: Vector2 = target.global_position - global_position
		var direction: Vector2 = distance_to_player.normalized()
		velocity = velocity.move_toward(direction * speed, acceleration)

func animate_enemy():
	if velocity.x > 0:
		$AnimatedSprite2D.play("move_right")
	if velocity.x < 0:
		$AnimatedSprite2D.play("move_left")


func _on_player_dectector_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body

func take_damage(damage: int):
	hit_points -= damage
	modulate = flash_hit_color
	
	if hit_points <= 0:
		die()
	
	await get_tree().create_timer(0.2).timeout
	
	if is_instance_valid(self):
		modulate = Color(1, 1, 1)

func die():
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	PlayerManager.amount_enemies_in_room -= 1
	queue_free()
