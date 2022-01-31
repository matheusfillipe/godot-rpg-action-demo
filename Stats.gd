extends Node

export(int) var max_health = 1 setget set_max_health

var health = max_health setget set_health
var grasses = 0 setget set_grass_count
var kills = 0
onready var initial_max_health = max_health
onready var start_time = OS.get_unix_time()


signal no_health
signal health_changed
signal max_health_changed
signal grass_count_changed
signal player_win

func win():
	emit_signal("player_win")

func reset_player():
	self.health = initial_max_health
	self.max_health = initial_max_health
	self.grasses = 0
	self.kills = 0
	start_time = OS.get_unix_time()

func set_grass_count(value):
	grasses = value
	emit_signal("grass_count_changed")

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")


func _ready():
	self.health = max_health
