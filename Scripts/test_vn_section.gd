extends Control
@onready var dialogueBox := preload("res://Scenes/dialogue_box.tscn")
@onready var text_lines := ["I cant believe we're really creating dialogue text. This is incredible!", "I love making video games.", "Uh oh, among us sussy???"]

@onready var dialogueContainer := $screenMargin/dialogueScroll/dialogueContainer
@onready var dialogueScroll := $screenMargin/dialogueScroll

func createRandomDialogue():
	var new_dialogue = dialogueBox.instantiate() as DialogueBox
	dialogueContainer.add_child(new_dialogue) 
	new_dialogue.initialize(randf_range(0,1) > 0.5, text_lines.pick_random(), "funko")
	
func _input(event):
	if Input.is_action_just_pressed("cheat"):
		print("CREATING NEW DIALOGUE")
		await createRandomDialogue()
		var new_child = dialogueContainer.get_child(-1)
		dialogueScroll.ensure_control_visible(new_child)

