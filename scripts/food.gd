extends Node3D

signal eaten

var time := 0.0

func _ready() -> void:
	$area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("food eat", body.name)
	if body.name == "Snake":
		eaten.emit()
		queue_free()


func _process(delta):
	time += delta
	rotate_y(delta * 2)
	position.y = 0 + sin(time * 3.0) * 0.1
