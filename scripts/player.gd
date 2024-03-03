extends Node3D
class_name Player

@onready var neck = $Neck as Node3D
@onready var camera = $Neck/Camera3D as Camera3D
@export var look_sensitivity = Vector2(1,1) as Vector2
var can_look = true as bool
var look_vector : Vector2
var stored_look_vector : Vector2

@onready var path = $Path3D as Path3D
@onready var handheld = $Path3D/HandHeld as Handheld
@onready var crosshair = $CanvasLayer/Control/Crosshair as TextureRect
@onready var move_sfx = $Move as AudioStreamPlayer3D

@onready var flashlight = $Flashlight as SpotLight3D
@onready var ray = $Neck/Camera3D/RayCast3D as RayCast3D

@export var environment : Node3D
var depth :float
const start_depth = 5 as float

func _ready():
	depth = start_depth
	handheld.set_depth_bar(depth)
	handheld.set_depth_text(depth)
	environment.global_position.y = depth

func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if can_look:
			if event is InputEventMouseMotion:
				look_vector = event.relative

func _process(delta):
	var to_hand = (handheld.global_position - camera.global_position).normalized()
	
	var dot = to_hand.dot(-camera.global_basis.z)
	var x = 0.08
	var map = remap(clamp(dot,1-x,1),1-x,1,0,1)
	
	if dot < 1-x: crosshair.modulate.a = 0
	else: crosshair.modulate.a = smoothstep(0,1,map)

func _physics_process(delta):
	look()
	path_sway(delta)
	lerp_flashlight(delta)
	ray_process(delta)

func look():
	if look_vector == Vector2.ZERO: pass
		#look_vector = Input.get_vector("look_left","look_right","look_up","look_down") * 15
	neck.rotate_y(-look_vector.x * 0.0025 * look_sensitivity.x)
	camera.rotate_x(-look_vector.y * 0.0025 * look_sensitivity.y)
	camera.rotation.x = clamp(camera.rotation.x , deg_to_rad(-70), deg_to_rad(89))
	neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-90), deg_to_rad(90))
	stored_look_vector = look_vector
	look_vector = Vector2.ZERO

func path_sway(delta: float):
	var new_rot : float
	var limit = 20 as float
	var speed = 1.5 as float
	
	new_rot = clamp(stored_look_vector.x * 2 * look_sensitivity.x, -limit, limit)
	path.rotation_degrees.y = lerp(path.rotation_degrees.y, new_rot, delta * speed)

func lerp_flashlight(delta:float):
	flashlight.global_basis = lerp(flashlight.global_basis, camera.global_basis, delta * 4)
	
	var to_hand = (handheld.global_position - camera.global_position).normalized()
	var y = 0.2
	var dot = to_hand.dot(-flashlight.global_basis.z)
	var map = remap(clamp(dot,1-y,1),1-y,1,0,1)
	flashlight.light_energy = lerp(1.5,0.05, map)

func ray_process(delta:float):
	var moving = false
	if Input.is_action_pressed("interact") and ray.is_colliding():
		moving = true
		
		var depth_change = 0
		if ray.get_collider().is_in_group("up"): depth_change = -1
		elif ray.get_collider().is_in_group("down"): depth_change = 1
		
		var fall_speed = 0.75
		if depth < start_depth: depth_change = clamp(depth_change,0,1)
		depth += depth_change * delta * fall_speed
		
		handheld.set_depth_bar(depth)
		handheld.set_depth_text(depth)
		
		environment.global_position.y = depth
		#environment.global_position.y += depth_change * delta * fall_speed
	
	move_sfx.stream_paused = not moving
