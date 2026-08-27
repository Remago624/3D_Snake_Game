extends Node3D

var time := 0.0



func _ready() -> void:
	$Area3D.body_entered.connect(_on_body_enterd)

func _process(delta): #making it spin (around the world around the world)
	time += delta
	rotate_y(delta * 2)
	position.y = 1 + sin(time * 3.0) * 0.1

func _on_body_enterd(body): 
		print("i like money  :", body.name)
		if body.name == "Snake":
			$GPUParticles3D.emitting = true
			$MeshInstance3D.visible = false
			Gamemaneger.money += 1
			await get_tree().create_timer(0.5).timeout
			queue_free()
