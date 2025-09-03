extends Area2D

@export var bounce_force: float = 500.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	add_to_group("Fire")
	body_entered.connect(self._on_body_entered)

	if sprite.sprite_frames and sprite.sprite_frames.has_animation("On"):
		sprite.play("On")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("โดน Fire:", body.name)
		if body.has_method("take_damage"):
			body.take_damage(1)

		body.velocity.y = -bounce_force

		if body.has_method("flash_red"):
			body.flash_red()
