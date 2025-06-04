extends Node2D

var player_hp: int = 100
var player_weapon_resource: Array[Resource]
var amount_enemies_in_room: int = 2

func _ready() -> void:
	player_weapon_resource.append(load("res://Scenes/Weapons/Unarmeds/Punch.tscn"))
	player_weapon_resource.append(load("res://Scenes/Weapons/Swords/Sword.tscn"))
