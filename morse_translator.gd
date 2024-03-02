extends Node
class_name Morse

const dict = {
	"A" : "01",
	"B" : "1000",
	"C" : "1010",
	"D" : "100",
	"E" : "0",
	"F" : "0010",
	"G" : "110",
	"H" : "0000",
	"I" : "00",
	"J" : "0111",
	"K" : "101",
	"L" : "0100",
	"M" : "11",
	"N" : "10",
	"O" : "111",
	"P" : "0110",
	"Q" : "1101",
	"R" : "010",
	"S" : "000",
	"T" : "1",
	"U" : "001",
	"V" : "0001",
	"W" : "011",
	"X" : "1001",
	"Y" : "1011",
	"Z" : "1100",
	" " : "/"
}

static func encrypt(string : String) -> String:
	var cypher = "" as String
	#print(string)
	for x in string:
		if not x == " ": x = x.capitalize()
		if dict.has(x): cypher += dict[x] + " "
	return cypher
