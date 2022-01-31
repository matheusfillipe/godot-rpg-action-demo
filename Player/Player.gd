extends KinematicBody2D

const PlayerHurtSound = preload("res://PlayerHurtSound.tscn")

export var MAX_SPEED = 100
export var ACCELERATION = 1200
export var DECELERATION = 1000
export var ROLL_SPEED = 130
export var INVINCIBILITY_TIME = .6

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $HurtBox

func _ready():
	# Change random seeds dinamically (used on Bat.gd)
	randomize()

	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	$HitboxPivot/SwordHitbox/CollisionShape2D.disabled = true
	swordHitbox.knock_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		roll_vector = input_vector
		swordHitbox.knock_vector = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)

	move()

	if Input.is_action_just_pressed("roll"):
		state = ROLL

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	state = MOVE
	velocity = velocity / 3


func _on_HurtBox_area_entered(area:Area2D):
	stats.health -= area.damage
	hurtbox.start_invicibility(INVINCIBILITY_TIME)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_HurtBox_invicibility_started():
	blinkAnimationPlayer.play("Start")

func _on_HurtBox_invicibility_ended():
	blinkAnimationPlayer.play("Stop")
