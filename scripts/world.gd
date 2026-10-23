extends Node3D
@onready var spawns = $Spawns
@onready var money_spawns = $money_spawns
@onready var food = load("res://scenes/food.tscn")
@onready var money = load("res://scenes/coin.tscn")
@export var spawn_radius: float = 6.7
@onready var snake = $Snake

func _ready() -> void:
	$HUD/ColorRect.visible = false
	randomize()

func _on_spawn_timer_timeout() -> void:
	print("food spaned")
	var random_point = randi() % spawns.get_child_count()
	var spawn_point = spawns.get_child(random_point).global_position
	var food_instance = food.instantiate()
	food_instance.position = spawn_point + Vector3(randf_range(-spawn_radius, spawn_radius), 0, randf_range(-spawn_radius, spawn_radius))
	food_instance.eaten.connect(snake.grow)
	add_child(food_instance)


func _on_spawn_money_timer_timeout() -> void:
	print("bta3y spawned")
	var money_random_point = randi() % money_spawns.get_child_count()
	var money_spawn_point = money_spawns.get_child(money_random_point).global_position
	var money_instance = money.instantiate()
	money_instance.position = money_spawn_point + Vector3(randf_range(-spawn_radius, spawn_radius), 0, randf_range(-spawn_radius, spawn_radius))
	add_child(money_instance)


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
	Gamemaneger.money = 0
	Gamemaneger.score = 0
	snake.process_mode = Node.PROCESS_MODE_INHERIT
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_button_2_pressed() -> void:
	snake.process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
