extends Control

@export_file("*.json") var scene_text_file: String

var scene_text = {}
var selected_text = []
var in_progress = false
var key
@export var active = false

@onready var background = $Background
@onready var text_label = $TextLabel


func _ready() -> void:
	background.visible = false
	scene_text = load_scene_text()
	SignalBus.display_dialog.connect(start)


func _input(event: InputEvent) -> void:
	if active:
		if Input.is_action_just_pressed("nes_a"):
			display_dialog()


func start(text_key):
	key = text_key
	get_tree().paused = true
	active = true
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
	else:
		finish()


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
