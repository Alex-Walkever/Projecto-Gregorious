extends CharacterBody2D
class_name Enemy

@export var speed: float = 300.0
@export var hit_points: int = 3
@export var flash_hit_color: Color = Color(5,0,0)
@export var acceleration: float = 5

func take_damage(_damage: int):
	pass
