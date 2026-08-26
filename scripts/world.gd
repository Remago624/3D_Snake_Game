extends Node3D

func spawn_food(pos):
	var food = preload("res://scenes/food.tscn").instantiate()
	food.global_position = pos
	food.eaten.connect(_on_food_eaten)
	add_child(food)

func _on_food_eaten():
	print("food siginal")
	$Snake.grow()
