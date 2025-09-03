extends Area2D
@onready var flag_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@export var next_scene: PackedScene

func _ready() -> void:
	#$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.keys >= 3:
			$AnimationPlayer.play("flag_up")
			AudioManager.level_complete_sfx.play()
		else:
			print("ยังมีกุญแจไม่ครบ! มีแค่ ", body.keys, " อัน")
		

		
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "flag_up" and next_scene:
		get_tree().change_scene_to_packed(next_scene)
		

		
