extends Camera2D

onready var topLeft = $Limits/TopLeft.global_position
onready var bottomRight = $Limits/BottomRight.global_position
onready var borderCollision = $Limits/StaticBody2D/CollisionPolygon2D

export(float) var margin = 20


func _ready():
	limit_top = topLeft.y
	limit_left = topLeft.x
	limit_bottom = bottomRight.y
	limit_right = bottomRight.x

	borderCollision.polygon = PoolVector2Array([
		Vector2(topLeft.x + margin, topLeft.y + margin),
		Vector2(topLeft.x + margin, bottomRight.y - margin),
		Vector2(bottomRight.x - margin, bottomRight.y - margin),
		Vector2(bottomRight.x - margin, topLeft.y + margin),
		Vector2(topLeft.x + margin, topLeft.y + margin),
		Vector2(topLeft.x - 1, topLeft.y - 1),
		Vector2(bottomRight.x + 1, topLeft.y - 1),
		Vector2(bottomRight.x + 1, bottomRight.y + 1),
		Vector2(topLeft.x - 1, bottomRight.y + 1)
	])
