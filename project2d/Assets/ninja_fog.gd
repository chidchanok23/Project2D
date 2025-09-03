extends CharacterBody2D

@export var speed := 200.0
@export var jump_velocity := -420.0
@export var gravity := 1200.0
@export var knockback_decay := 2000.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

#var lives: int = 3 #ค่า HP
#var score: int = 0 #คะแนน coin
var keys: int = 0 #จำนวนกุญแจที่เก็บได้
var dead: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("Player")
	AudioManager.music_sfx.play()
	var spawn = get_tree().current_scene.get_node_or_null("SpawnPoint")
	if spawn:
		global_position = spawn.global_position
		
func _physics_process(delta):
	if dead:
		return

	var direction := Input.get_axis("left", "right")

	# horizontal จาก input
	velocity.x = direction * speed

	# กระโดดเอง
	if Input.is_action_just_pressed("jump") and is_on_floor():
		AudioManager.jump_sfx.play()
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
	if global_position.y > 328:
		die()
	
func take_damage(amount: int = 1) -> void:
	AudioManager.death_sfx.play()
	GameManager.lives -= amount
	print("Ninja Fog ถูกโจมตี! ชีวิตเหลือ:", GameManager.lives)
	flash_red()
	if GameManager.lives <= 0:
		die()

func flash_red():
	AudioManager.death_sfx.play()
	anim.modulate = Color(1, 0, 0)
	var t = get_tree().create_timer(1.0)
	t.timeout.connect(func ():
		anim.modulate = Color(1, 1, 1))
		

func die() -> void:
	dead = true
	#GameManager.lives = 0
	AudioManager.death_sfx.play()
	print("Ninja Fog ตายแล้ว! คะแนนสุดท้าย:", GameManager.score, " | กุญแจ:", keys)
	velocity = Vector2.ZERO
	knockback_velocity = Vector2.ZERO
	get_tree().call_group("UI", "reset_player")
	respawn() # เรียก respawn ตอนตาย

func respawn() -> void:
	await get_tree().create_timer(0.1).timeout # หน่วงเวลา 1 วิ
	get_tree().change_scene_to_file("res://level_01.tscn")
	AudioManager.respawn_sfx.play()
	

func add_score(amount: int = 1) -> void: # func เพิ่มคะแนนจากการเก็บ coin
	GameManager.score += amount
	AudioManager.coin_pickup_sfx.play()
	print("คะแนนเพิ่ม:", amount, " | คะแนนปัจจุบัน:", GameManager.score)
	if GameManager.score >= 100:
		if GameManager.lives < 3:
			GameManager.lives += 1
			GameManager.score -= 100  # หักออก 100 หลังได้หัวใจ
			print("ครบ 100 เหรียญ! ❤️ เพิ่มหัวใจ 1 ดวง | ชีวิต:", GameManager.lives)
		else:
			# ถ้าหัวใจเต็ม 3 ดวง ให้คะแนนยังคงสะสมต่อไป
			print("หัวใจเต็มแล้ว ไม่เพิ่ม ❤️")

func add_key(amount: int = 1) -> void: # func เพิ่มจำนวนกุญแจ
	keys += amount
	AudioManager.coin_pickup_sfx.play()
	print("ได้กุญแจเพิ่ม:", amount, " | กุญแจที่มี:", keys)

func apply_knockback(kb: Vector2) -> void:
	knockback_velocity = kb
