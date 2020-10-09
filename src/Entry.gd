extends HBoxContainer
class_name Entry

signal remove_button_pressed(entry)
signal text_button_pressed(entry)

var text := "" setget _set_text

onready var text_button := $TextButton
onready var remove_button := $RemoveButton


func _ready() -> void:
	_set_text(text)


func _set_text(value: String) -> void:
	text = value

	if text_button:
		text_button.text = value


func _on_TextButton_pressed() -> void:
	emit_signal("text_button_pressed", self)


func _on_RemoveButton_pressed() -> void:
	emit_signal("remove_button_pressed", self)
