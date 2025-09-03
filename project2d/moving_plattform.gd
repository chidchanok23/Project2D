extends Path2D

const PLATTFORM_SPEED = 50
var direction := 1  # 1 = ไปข้างหน้า, -1 = ถอยกลับ

func _physics_process(delta: float) -> void:
	var pf = $PathFollow2D
	pf.progress += PLATTFORM_SPEED * delta * direction

	# เช็คว่าถึงปลายทางหรือยัง
	if pf.progress_ratio >= 1.0:
		direction = -1
	elif pf.progress_ratio <= 0.0:
		direction = 1
