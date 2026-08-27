extends Node3D
@onready var spawns = $Spawns
@onready var food = load("res://scenes/food.tscn")
@export var spawn_radius: float = 6.7
@onready var snake = $Snake

func _ready() -> void:
	randomize()

func _on_spawn_timer_timeout() -> void:
	print("food spaned")
	var random_point = randi() % spawns.get_child_count()
	var spawn_point = spawns.get_child(random_point).global_position
	var food_instance = food.instantiate()
	food_instance.position = spawn_point + Vector3(randf_range(-spawn_radius, spawn_radius), 0, randf_range(-spawn_radius, spawn_radius))
	food_instance.eaten.connect(snake.grow)
	add_child(food_instance)
