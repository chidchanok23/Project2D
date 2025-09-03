extends Control

@onready var coin_texture = %Coin/CoinTexture
@onready var coin_label = %Coin/CoinLabel
@onready var key_texture = %Key/KeyTexture
@onready var key_label = %Key/KeyLabel
@onready var hearts = [$Heart/HeartTexture1, $Heart/HeartTexture2, $Heart/HeartTexture3]
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	add_to_group("UI")
	
func _process(_delta):
	if not player:
		player = get_tree().get_first_node_in_group("Player")
		return
	coin_label.text = str(GameManager.score)
	key_label.text = str(player.keys)
	for i in range(hearts.size()):
		hearts[i].visible = i < GameManager.lives
		
func reset_player():
	if not player:
		player = get_tree().get_first_node_in_group("Player")
		
	GameManager.lives = 3
	GameManager.score = 0
	player.keys = 0
	# รีเซต UI ด้วย
	coin_label.text = str(GameManager.score)
	key_label.text = str(player.keys)
	for i in range(hearts.size()):
		hearts[i].visible = true
