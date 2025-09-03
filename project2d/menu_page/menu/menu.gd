extends Control

@export var start_scene: PackedScene
@onready var start_btn: Button = $VBoxContainer/Start_btn
@onready var quit_btn: Button = $VBoxContainer/Quit_btn

func _ready() -> void:
	start_btn.pressed.connect(_on_start_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	if start_scene:
		get_tree().change_scene_to_packed(start_scene)
	else:
		push_warning("⚠ ยังไม่ได้ตั้งค่า start_scene ใน Inspector")

func _on_quit_pressed() -> void:
	get_tree().quit()
