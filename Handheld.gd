extends PathFollow3D

@export var screen_active = true as bool
@onready var dot_sfx = $Dot as AudioStreamPlayer3D
@onready var dash_sfx = $Dash as AudioStreamPlayer3D

var txt_stack : Array[String]
@onready var text = $ScreenUI/Control/RichTextLabel as RichTextLabel
@onready var word_end = $WordEnd as Timer
signal stack_finished

func _ready():
	toggle_screen(screen_active)
	add_to_stack("the normalized scalar product is the cosine of the angle between the two vectors")

func add_to_stack(string:String):
	for x in string:
		if x != " ": x = x.capitalize()
		if Morse.dict.has(x): txt_stack.append(x)
		#print(Morse.encrypt(x))

func read_from_stack() -> String:
	if txt_stack.size() == 0: return ""
	var x = txt_stack[0]
	return x
	#if x == "/": x = " "

var morse_count = 0 as int

func morse_tick():
	if not word_end.is_stopped() or txt_stack.size() == 0: return
	
	var x = Morse.encrypt(read_from_stack())
	
	if morse_count >= x.length():
		text.text += read_from_stack()
		txt_stack.pop_front()
		morse_count = 0
		
		if txt_stack.size() == 0: stack_finished.emit()
		elif read_from_stack() == " ": word_end.start()
		
		return
	
	if screen_active:
		if x[morse_count] == "0": dot_sfx.play()
		elif x[morse_count] == "1": dash_sfx.play()
	
	print(x[morse_count])
	morse_count += 1

func clear_text():
	text.text = ""

func toggle_screen(x : bool):
	screen_active = x
	$Offset/Screen.visible = x
