extends CharacterBody3D

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var tails_parent = $Tails

const speed = 5.0
const jump_velocity = 4.5
var mouse_sense = 0.2

var target_y: float
const turn_smooth = 5.0

var tails: Array[Node3D] = []
const segment_distance = 0.5
const follow_smooth = 15.0

var postion_history = []
const history_spacing = 0.05

var tail_scene = preload("res://scenes/Tail_1.tscn")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	target_y = rotation.y
	for child in tails_parent.get_children():
		if child is Node3D:
			tails.append(child)
			child.rotation = Vector3.ZERO
	postion_history.append(global_position)

func _input(event):
	if event is InputEventMouseMotion:
		target_y += deg_to_rad(-event.relative.x * mouse_sense)
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-67), deg_to_rad(67))

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	rotation.y = lerp_angle(rotation.y, target_y, delta * turn_smooth)
	head.rotation.y = target_y - rotation.y


	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (head.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, 0.0, delta * 3.0)
			velocity.z = lerp(velocity.z, 0.0, delta * 3.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 0.6)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 0.6)
	move_and_slide()
	
	_update_postion_history()
	_update_tails(delta)

func _update_postion_history():
	if postion_history.is_empty():
		postion_history.append(global_position)
		return
	
	if global_position.distance_to(postion_history[0]) >= history_spacing:
		postion_history.push_front(global_position)
		
	var max_history = (tails.size() + 1) * int(segment_distance / history_spacing) + 30
	if postion_history.size() > max_history:
		postion_history.resize(max_history)

func _update_tails(delta):
	for i in range(tails.size()):
		var tail = tails[i]
		var history_index = int((i + 1) * segment_distance / history_spacing)
		if history_index >= postion_history.size():
			history_index = postion_history.size() - 1
		if history_index < 0:
			continue
		var target_position = postion_history[history_index]
		tail.global_position = tail.global_position.lerp(target_position, delta * follow_smooth)
		var look_diriction = target_position - tail.global_position
		
		if look_diriction.length() > 0.01:
			var target_angle = atan2(look_diriction.x, look_diriction.z)
			tail.rotation.y = lerp_angle(tail.rotation.y, target_angle, delta * 2.0)


func grow():
	print("grow is active")
	var new_tail = tail_scene.instantiate()
	var last = tails[-1] if tails.size() > 0 else self
	tails_parent.add_child(new_tail)
	
	var direction = last.global_position - global_position
	if direction.length() < 0.01:
		direction = Vector3(0, 0, 1)
	
	direction = direction.normalized()
	new_tail.global_position = last.global_position + direction * segment_distance
	new_tail.rotation = Vector3.ZERO
	tails.append(new_tail)
