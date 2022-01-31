extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible
onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invicibility_started
signal invicibility_ended

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invicibility_started")
	else:
		emit_signal("invicibility_ended")

func start_invicibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	self.invincible = false

func _on_HurtBox_invicibility_started():
	collisionShape.set_deferred("disabled", true)

func _on_HurtBox_invicibility_ended():
	collisionShape.set_deferred("disabled", false)
