extends Sprite2D
class_name Weapon

enum WeaponType{
	sword,
	unarmed
}

@export var damage: int = 1
@export var type: WeaponType = WeaponType.unarmed
@export var max_combo: int = 1
@export var knockback_strength: float = 150.0

var combo_count: int = 0
var is_attacking: bool = false
var last_direction: float = 1.0

func main_action():
	combo_count += 1
	is_attacking = true

func secundary_action():
	pass

func set_direction(direction: float):
	last_direction = direction

func deal_damage(body: Node2D) -> void:
	if body is Enemy:
		var distance_to_enemy: Vector2 = body.global_position - global_position
		var direction: Vector2 = distance_to_enemy.normalized()
		body.velocity += direction * knockback_strength
	
	body.take_damage(damage)
