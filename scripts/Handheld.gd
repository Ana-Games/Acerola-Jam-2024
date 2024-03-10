extends PathFollow3D
class_name Handheld

@export var screen_active = true as bool
@onready var dot_sfx = $Dot as AudioStreamPlayer3D
@onready var dash_sfx = $Dash as AudioStreamPlayer3D
@onready var depth_text = $DepthUI/Control/Panel/RichTextLabel as RichTextLabel
@onready var depth_bar = $DepthUI/Control/Panel/Depth as TextureRect

var txt_stack : Array[String]
@onready var text = $ScreenUI/Control/RichTextLabel as RichTextLabel
@onready var word_end_timer = $WordEnd as Timer
@onready var morse_timer = $MorseTick as Timer
signal stack_finished

func _ready():
	toggle_screen(screen_active)
	#print(get_morse_time("ground is depth 200"))

func add_to_stack(string:String):
	for x in string:
		if x != " ": x = x.capitalize()
		if Morse.dict.has(x) or x == "#": txt_stack.append(x)
		#print(Morse.encrypt(x))

func read_from_stack() -> String:
	if txt_stack.size() == 0: return ""
	var x = txt_stack[0]
	return x
	#if x == "/": x = " "

var morse_count = 0 as int

func morse_tick():
	if not word_end_timer.is_stopped() or txt_stack.size() == 0: return
	
	if txt_stack[0] == "#": txt_stack.pop_front()
	var x = Morse.encrypt(read_from_stack())
	
	if morse_count >= x.length():
		text.text += read_from_stack()
		txt_stack.pop_front()
		morse_count = 0
		
		if txt_stack.size() == 0: stack_finished.emit()
		elif read_from_stack() == " ": word_end_timer.start()
		
		return
	
	if screen_active:
		if x[morse_count] == "0": dot_sfx.play()
		elif x[morse_count] == "1": dash_sfx.play()
	
	if txt_stack.size() > 1 and txt_stack[1] == "#":
		if x[morse_count] == "0": $Tap_Dot.play()
		elif x[morse_count] == "1": $Tap_Dash.play()
	
	print(x[morse_count])
	morse_count += 1

func clear_text():
	text.text = ""

func toggle_screen(x : bool):
	screen_active = x
	$Offset/Screen.visible = x

func set_depth_bar(pos:float):
	depth_bar.position.y = pos

func set_depth_text(x : float):
	if x <= 999:
		depth_text.text = str(round(x))
		var size = depth_text.text.length()
		if size < 3: 
			for i in range((3-size)):
				depth_text.text = "O" + depth_text.text

func get_morse_time(code : String) -> float:
	var count = 0 as float
	for x in code:
		if x == " ":
			count += word_end_timer.wait_time
			continue
		var encode = Morse.encrypt(x)
		for y in encode: count += morse_timer.wait_time
	return count
