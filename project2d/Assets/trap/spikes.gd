extends Area2D

@export var bounce_force: float = 500.0
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	add_to_group("Spike")
	body_entered.connect(self._on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		if body.has_method("flash_red"):
			body.flash_red()
			
		print("โดน Spike:", body.name)
		
		if body.has_method("take_damage"):
			body.take_damage(1)
		body.velocity.y = -bounce_force

		
