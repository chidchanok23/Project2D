extends StaticBody2D
@export var is_active: bool = true

func _ready() -> void:
	$CollisionShape2D.disabled = not is_active

func enable_wall(body: Node) -> void:
	if body.is_in_group("monster"):
		$CollisionShape2D.disabled = false

func disable_wall() -> void:
	$CollisionShape2D.disabled = true
