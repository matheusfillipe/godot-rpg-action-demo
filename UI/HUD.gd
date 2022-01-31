extends CanvasLayer

var stats = PlayerStats
var dead = false

func _ready():
	stats.connect("no_health", self, "die")
	stats.connect("player_win", self, "win")

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
	if dead and Input.is_action_just_pressed("roll"):
		$AnimationPlayer.play("menu_action")
		stats.reset_player()
		get_tree().paused = false
		get_tree().reload_current_scene()

func die():
	$AnimationPlayer.play("death")
	$Ingame.visible = false
	$Retry.visible = true
	dead = true

func win():
	get_tree().paused = true
	$AnimationPlayer.play("win")
	$Retry.visible = true
	dead = true

	var now = OS.get_time();
	var start = stats.start_time
	$Retry/Label.text = str(start.hour - now.hour) + " Hours " + str(start.minute - now.minute) + " minutes and " + str(start.second - now.second) + " seconds"


func toggle_pause():
	var is_paused = get_tree().paused
	get_tree().paused = not is_paused
	$Pause.visible = not is_paused
	$AnimationPlayer.play("menu_action")


func _on_GrassCounter_upgrade():
	$AnimationPlayer.play("upgrade")