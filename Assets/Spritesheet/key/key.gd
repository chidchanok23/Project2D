extends Area2D

@export var value: int = 1
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	add_to_group("Key")
	anim.play("key")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		if body.has_method("add_key"):
			body.add_key(value)
		queue_free()
