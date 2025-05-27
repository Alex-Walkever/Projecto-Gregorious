extends Weapon

func main_action():
	if $AttackTimer.is_stopped():
		super()
		visible = true
		$HitBox.monitoring = true
		$AttackTimer.start()
		play_animation()

func secundary_action():
	super()


func _on_attack_timer_timeout() -> void:
	combo_count = 0
	visible = false
	is_attacking = false
	$HitBox.monitoring = false
	
func play_animation():
	match last_direction:
		1.0: $PunchAnimation.play("attack1_right")
		-1.0: $PunchAnimation.play("attack1_left") 
