extends CharacterBody3D

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var tails_parent = $"../Node3D"
const speed = 5.0
const jump_velocity = 4.5
var mouse_sense = 0.2

var target_y: float
const turn_smooth = 5.0

var tails: Array[Node3D] = []
const segment_distance: float = 1.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	target_y = rotation.y
	
	for child in tails_parent.get_children():
		if child.name.begins_with("Tail"):
			tails.append(child)
	tails.sort_custom(func(a, b): return a.name > b.name)



func _input(event):
	if event is InputEventMouseMotion:
		#rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
		target_y += deg_to_rad(-event.relative.x * mouse_sense)
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
		#target_cam_x += deg_to_rad(-event.relative.y * mouse_sense)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-67), deg_to_rad(67))
		#target_cam_x = clamp(camera.rotation.x, deg_to_rad(-67), deg_to_rad(67))

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	rotation.y = lerp_angle(rotation.y, target_y, delta * turn_smooth)
	head.rotation.y = target_y - rotation.y


	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = jump_velocity


	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (head.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 0.6)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 0.6)
	move_and_slide()

	_update_tails()

func _update_tails():
	for i in range(tails.size()):
		var leader = self if i == 0 else tails[i - 1]
		var tail = tails[i]
		var dist = tail.global_position.distance_to(leader.global_position)
		
		if dist > segment_distance:
			var dir = tail.global_position.direction_to(leader.global_position)
			tail.global_position = leader.global_position - dir * segment_distance
		
		tail.look_at(leader.global_position, Vector3.UP)
		tail.rotation.x = deg_to_rad(-90)
		tail.rotation.z = 0

var tail_scene = preload("res://scenes/Tail.tscn")

func grow():
	print("grow is active")
	var new_tail = tail_scene.instantiate()
	var last = tails[-1] if tails.size() > 0 else self
	tails_parent.add_child(new_tail)
	new_tail.global_position = last.global_position
	
	tails.append(new_tail)
