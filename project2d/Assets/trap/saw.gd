extends Area2D

@export var start_position: Vector2
@export var end_position: Vector2
@export var speed: float = 200.0
@export var damage: int = 1
@export var bounce_vertical: float = 300.0
@export var bounce_horizontal: float = 200.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var moving_forward: bool = true

func _ready():
	position = start_position
	add_to_group("Saw")
	body_entered.connect(_on_body_entered)
	if anim.sprite_frames.has_animation("On"):
		anim.play("On")

func _physics_process(delta):
	if moving_forward:
		position = position.move_toward(end_position, speed * delta)
		if position.distance_to(end_position) < 1:
			moving_forward = false
	else:
		position = position.move_toward(start_position, speed * delta)
		if position.distance_to(start_position) < 1:
			moving_forward = true

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		if body.has_method("flash_red"):
			body.flash_red()
			
		print("โดน Saw:", body.name)
		if body.has_method("take_damage"):
			body.take_damage(damage)

		var vertical = -bounce_vertical
		if not body.is_on_floor():
			vertical *= 0.5

		var kb_x: float = 0.0
		if body.has_method("get_direction"):
			var dir = body.get_direction()
			kb_x = -bounce_horizontal if dir > 0 else bounce_horizontal
		else:
			kb_x = -bounce_horizontal 
		var kb = Vector2(kb_x, vertical)
		if body.has_method("apply_knockback"):
			body.apply_knockback(kb)
