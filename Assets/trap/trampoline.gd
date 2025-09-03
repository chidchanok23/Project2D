extends CharacterBody2D  

@export var bounce_force: float = -840
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var overlapping_players: Array = []

func _ready():
	add_to_group("Trampoline")

func _on_jump_area_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		AudioManager.jump_sfx.play()
		body.velocity.y = bounce_force

		if anim and anim.sprite_frames and anim.sprite_frames.has_animation("jump"):
			anim.play("jump")
			debug_animation()

		if body not in overlapping_players:
			overlapping_players.append(body)

func _on_jump_area_body_exited(body: Node) -> void:
	if body in overlapping_players:
		overlapping_players.erase(body)

	if overlapping_players.is_empty():
		if anim and anim.sprite_frames and anim.sprite_frames.has_animation("idle"):
			anim.play("idle")
			debug_animation()
			
func debug_animation():
	if anim and anim.sprite_frames:
		print("--- Debug ---")
		print("Available animations:", anim.sprite_frames.get_animation_names())
		print("Current animation:", anim.animation)
		print("Is playing:", anim.is_playing())
