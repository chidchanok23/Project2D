extends Area2D

@onready var reward_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label
@export var next_scene: PackedScene

func _ready() -> void:
	label.hide()  # ซ่อน Label ตอนเริ่ม
	reward_anim.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.keys >= 3:
			AudioManager.level_complete_sfx.play()
			reward_anim.play("reward")  # เล่นแอนิเมชันของ AnimatedSprite2D
			label.show()
			await get_tree().create_timer(5).timeout  # รอ 10 วินาที
			label.hide()  # ซ่อน label หลังรอ 10 วินาที
			_on_animation_finished()
		else:
			print("ยังมีกุญแจไม่ครบ! มีแค่ ", body.keys, " อัน")
			label.hide()

func _on_animation_finished() -> void:
	# AnimatedSprite2D ไม่ส่งชื่อแอนิเมชันมา ต้องเช็คเอง
	if reward_anim.animation == "reward" and next_scene:
		get_tree().change_scene_to_packed(next_scene)
