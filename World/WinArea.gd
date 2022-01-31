extends Area2D



func _on_WinArea_area_entered(area):
	print("Game ended!!")
	PlayerStats.win()


func _on_WinArea_body_entered(body):
	print("Game ended!!")
	PlayerStats.win()
