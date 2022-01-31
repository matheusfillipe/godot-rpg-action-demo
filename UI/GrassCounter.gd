extends Control

export(int) var life_update_count = 15

signal upgrade

func update_count():
	if PlayerStats.grasses > life_update_count:
		PlayerStats.set_max_health(PlayerStats.max_health + 1)
		PlayerStats.set_health(PlayerStats.max_health)
		PlayerStats.grasses = 0
		emit_signal("upgrade")

	$HBoxContainer/Label.text = str(PlayerStats.grasses)

func _ready():
	PlayerStats.connect("grass_count_changed", self, "update_count")
