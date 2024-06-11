extends Control

@export_file("*.json") var scene_text_file: String

var scene_text = {}
var selected_text = []
var in_progress = false
var key

var active = false
var choices_active = false

@onready var background = $Background
@onready var text_label = $TextLabel


func _ready() -> void:
	background.visible = false
	scene_text = load_scene_text()
	SignalBus.display_dialog.connect(start)


func _input(event: InputEvent) -> void:
	if active and not choices_active:
		if Input.is_action_just_pressed("nes_a"):
			display_dialog()


func start(text_key):
	key = text_key
	get_tree().paused = true
	active = true
	choices_active = false
	background.visible = true
	in_progress = true
	selected_text = scene_text[key]["text"].duplicate()
	show_text()


func load_scene_text():
	if FileAccess.file_exists(scene_text_file):
		var file = FileAccess.open(scene_text_file, FileAccess.READ).get_as_text()
		return JSON.parse_string(file)


func show_text():
	if selected_text.size() > 0:
		text_label.text = selected_text.pop_front()
	elif scene_text[key].has("choices"):
		text_label.text = ""
		show_choices()
	else:
		finish()


func show_choices():
	choices_active = true
	var choice_text = scene_text[key]["choices"]
	$Choices.visible = true
	$Choices/Choice1.grab_focus()
	$ChoiceTImer.start()
	$Choices/Choice1.text = choice_text[0]["text"]
	$Choices/Choice2.text = choice_text[1]["text"]


func hide_choices():
	$Choices.visible = false
	$Choices/Choice1.disabled = true
	$Choices/Choice2.disabled = true


func finish():
	active = false
	text_label.text = ""
	background.visible = false
	in_progress = false
	get_tree().paused = false
	SignalBus.dialog_finished.emit()


func display_dialog():
	if in_progress:
		show_text()
	else:
		finish()


func _on_choice_1_pressed() -> void:
	start(scene_text[key]["choices"][1]["next"])
	hide_choices()


func _on_choice_2_pressed() -> void:
	start(scene_text[key]["choices"][0]["next"])
	hide_choices()


func _on_choice_t_imer_timeout() -> void:
	$Choices/Choice1.disabled = false
	$Choices/Choice2.disabled = false
