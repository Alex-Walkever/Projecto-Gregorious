extends Weapon

func main_action():
	if $AttackTimer.is_stopped() and combo_count < max_combo:
		super()
		visible = true
		$HitBox.monitoring = true
		$AttackComboTimer.start()
		$AttackTimer.start()
		play_animation()

func play_animation():
	match  combo_count:
		1: 
			if last_direction == 1: 
				$SwordAnimation.play("attack1_right")
			else:
				$SwordAnimation.play("attack1_left")
		2: 
			if last_direction == 1: 
				$SwordAnimation.play("attack2_right")
			else:
				$SwordAnimation.play("attack2_left")
		3: 
			if last_direction == 1: 
				$SwordAnimation.play("attack3_right")
			else:
				$SwordAnimation.play("attack3_left")

func secundary_action():
	super()
	pass


func _on_attack_timer_timeout() -> void:
	visible = false
	is_attacking = false
	$HitBox.monitoring = false


func _on_attack_combo_timer_timeout() -> void:
	combo_count = 0


func _on_attack_cooldown_timer_timeout() -> void:
	pass
