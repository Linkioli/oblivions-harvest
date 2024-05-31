extends Area2D

@export var dialog_key = ""

@export var area_active = false


func _ready() -> void:
	SignalBus.dialog_finished.connect(on_dialog_finished)


func _input(event: InputEvent) -> void:
	if area_active and Input.is_action_pressed("nes_a"):
		SignalBus.emit_signal("display_dialog", dialog_key)


func on_dialog_finished():
	area_active = false
	$CoolDownTimer.start()


func _on_area_entered(area: Area2D) -> void:
	area_active = true


func _on_area_exited(area: Area2D) -> void:
	area_active = false
	$CoolDownTimer.stop()


func _on_cool_down_timer_timeout() -> void:
	area_active = true
