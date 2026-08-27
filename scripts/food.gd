extends Node3D

signal eaten

var time := 0.0

func _ready() -> void:
	$area.body_entered.connect(_on_body_entered)

func _on_body_entered(body): #emiting a signal
	print("food eat", body.name)
	if body.name == "Snake":
		eaten.emit()
		queue_free()
		Gamemaneger.score += 100


func _process(delta): #making it spin (around the world around the world)
	time += delta
	rotate_y(delta * 2)
	position.y = 0 + sin(time * 3.0) * 0.1
