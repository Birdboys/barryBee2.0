extends Control
class_name DialogueBox

@onready var dialogueText := $dialogueBox/dialogueText
@onready var dialogueBox := $dialogueBox
@onready var speakerFrame := $speakerFrameSprite
@onready var bgFillLeft := $speakerFrameSprite/bgFillLeft
@onready var bgFillRight := $speakerFrameSprite/bgFillRight
@onready var textTimer := $textTimer
@onready var initial_wait := 0.5
@onready var special_chars := [' ','.','!','?']
@onready var random
var left_side : bool
var finished := false

func _ready():
	textTimer.timeout.connect(revealCharacter)
	dialogueText.visible_characters = 0

func initialize(is_left: bool, dialogue: String, character_sprite: String, speed:=1.0):
	left_side = is_left
	dialogueText.parse_bbcode(dialogue)
	print(dialogueText.get_parsed_text(), len(dialogueText.get_parsed_text()))
	if left_side:
		move_child(speakerFrame, -1)
		bgFillLeft.visible = true
		bgFillRight.visible = false	
	else:
		bgFillLeft.visible = false
		bgFillRight.visible = true
	
	textTimer.start(initial_wait)
	call_deferred("grab_focus")

func revealCharacter():
	var text_string = dialogueText.get_parsed_text()
	dialogueText.visible_characters += 1
	if dialogueText.visible_characters == len(text_string):
		finished = true
		textTimer.stop()
		return
	if text_string[dialogueText.visible_characters-1] in special_chars:
		textTimer.start(0.012)
	else:
		textTimer.start(randf_range(0.005,0.010))
	
