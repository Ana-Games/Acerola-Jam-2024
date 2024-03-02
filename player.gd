extends Node3D

@onready var neck = $Neck as Node3D
@onready var camera = $Neck/Camera3D as Camera3D
@export var look_sensitivity = Vector2(1,1) as Vector2
var can_look = true as bool
var look_vector : Vector2
var stored_look_vector : Vector2

@onready var path = $Path3D as Path3D

func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if can_look:
			if event is InputEventMouseMotion:
				look_vector = event.relative

func _physics_process(delta):
	look()
	path_sway(delta)

func look():
	if look_vector == Vector2.ZERO: pass
		#look_vector = Input.get_vector("look_left","look_right","look_up","look_down") * 15
	neck.rotate_y(-look_vector.x * 0.0025 * look_sensitivity.x)
	camera.rotate_x(-look_vector.y * 0.0025 * look_sensitivity.y)
	camera.rotation.x = clamp(camera.rotation.x , deg_to_rad(-50), deg_to_rad(89))
	neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-60), deg_to_rad(60))
	stored_look_vector = look_vector
	look_vector = Vector2.ZERO

func path_sway(delta: float):
	var new_rot : float
	var limit = 20 as float
	var speed = 1.5 as float
	
	new_rot = clamp(stored_look_vector.x * 2, -limit, limit)
	path.rotation_degrees.y = lerp(path.rotation_degrees.y, new_rot, delta * speed)


