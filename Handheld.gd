extends PathFollow3D

var txt_stack : Array[String]
@onready var text = $SubViewport/Control/RichTextLabel as RichTextLabel
@onready var dot_sfx = $Dot as AudioStreamPlayer3D
@onready var dash_sfx = $Dash as AudioStreamPlayer3D
@onready var word_end = $WordEnd as Timer

func _ready():
	add_to_stack("hello there my name is ana this is a working morse code translating device in godot")

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
		if read_from_stack() == " ": word_end.start()
		return
	if x[morse_count] == "0": dot_sfx.play()
	elif x[morse_count] == "1": dash_sfx.play()
	print(x[morse_count])
	morse_count += 1

func clear_text():
	text.text = ""
