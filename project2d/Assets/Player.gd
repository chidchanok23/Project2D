extends Node2D
@export var speed := 50
var can_move := false
func  _ready() -> void:
	
		$AnimationPlayer.play("stand")
		await get_tree().create_timer(3).timeout
		
		can_move = true
		$AnimationPlayer.play("walk")
		await get_tree().create_timer(6).timeout
		
		
		can_move = false
		$AnimationPlayer.play("jump")
		await get_tree().create_timer(3).timeout
		can_move = true
		$AnimationPlayer.play("walk")
		await get_tree().create_timer(3).timeout
		can_move = false
		$AnimationPlayer.play("punch")
		await get_tree().create_timer(3.6).timeout
		can_move = true
		speed = 100
		$AnimationPlayer.play("walk")
		await get_tree().create_timer(6).timeout
		
		
		
func _process(delta: float) -> void:
		if can_move:
			position.x += speed * delta
