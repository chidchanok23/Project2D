extends CharacterBody2D

@export var speed := 200.0
@export var jump_velocity := -700.0
@export var gravity := 1200.0
@export var knockback_decay := 2000.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var lives: int = 3 #ค่า HP
var score: int = 0 #คะแนน coin
var keys: int = 0 #จำนวนกุญแจที่เก็บได้
var dead: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("Player")

func _physics_process(delta):
	if dead:
		return

	var direction := Input.get_axis("left", "right")

	# horizontal จาก input
	velocity.x = direction * speed

	# กระโดดเอง
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if not is_on_floor():
		velocity.y += gravity * delta

	velocity += knockback_velocity

	move_and_slide()

	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)

	if not is_on_floor():
		anim.play("jump_down") if velocity.y < 0 else anim.play("jump_up")
	else:
		if direction != 0:
			anim.play("walk")
		else:
			anim.play("idle")
		anim.flip_h = direction < 0 if direction != 0 else anim.flip_h
		
func take_damage(amount: int = 1) -> void:
	lives -= amount
	print("Ninja Fog ถูกโจมตี! ชีวิตเหลือ:", lives)
	flash_red()
	if lives <= 0:
		die()

func flash_red():
	anim.modulate = Color(1, 0, 0)
	var t = get_tree().create_timer(1.0)
	t.timeout.connect(func ():
		anim.modulate = Color(1, 1, 1))

func die() -> void:
	dead = true
	print("Ninja Fog ตายแล้ว! คะแนนสุดท้าย:", score, " | กุญแจ:", keys)
	velocity = Vector2.ZERO
	knockback_velocity = Vector2.ZERO

func add_score(amount: int = 1) -> void: # func เพิ่มคะแนนจากการเก็บ coin
	score += amount
	print("คะแนนเพิ่ม:", amount, " | คะแนนปัจจุบัน:", score)

func add_key(amount: int = 1) -> void: # func เพิ่มจำนวนกุญแจ
	keys += amount
	print("ได้กุญแจเพิ่ม:", amount, " | กุญแจที่มี:", keys)

func apply_knockback(kb: Vector2) -> void:
	knockback_velocity = kb
