extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeadEffect.tscn")

var knockback = Vector2.ZERO

export var DECELERATION = 200
export var KNOCKBACK = 150

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var state = CHASE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $HurtBox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

export var ACCELERATION = 100
export var MAX_SPEED = 50
export var FRICTION = 200

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, DECELERATION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			update_wander()

		WANDER:
			seek_player()
			update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_wander()

		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func update_wander():
	if wanderController.get_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(1, 3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_HurtBox_area_entered(area):
	var knock_vector = area.knock_vector
	stats.health -= area.damage
	knockback = knock_vector * KNOCKBACK
	hurtbox.create_hit_effect()
	hurtbox.start_invicibility(0.4)


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_HurtBox_invicibility_started():
	animationPlayer.play("Start")


func _on_HurtBox_invicibility_ended():
	animationPlayer.play("Stop")
