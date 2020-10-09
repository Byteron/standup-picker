extends HBoxContainer
class_name AddEntry

signal entry_added(alias)

onready var line_edit := $LineEdit


func _on_Button_pressed() -> void:
	if not line_edit.text:
		return

	emit_signal("entry_added", line_edit.text)
	line_edit.text = ""
