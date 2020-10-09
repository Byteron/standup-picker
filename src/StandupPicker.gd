extends Control
class_name StandupPicker

const DEFAULT = [
	"Canberk",
	"Tim",
	"Maria",
	"Aaron",
	"Paul",
	"Dominik",
	"Elija",
	"Lois"
]

export var Entry : PackedScene = null

var entries := []
var active := []
var inactive := []

onready var active_container := $CenterContainer/VBoxContainer/HBoxContainer/Active/Container
onready var inactive_container := $CenterContainer/VBoxContainer/HBoxContainer/Inactive/Container

onready var winner_label := $CenterContainer/VBoxContainer/HBoxContainer/Active/WinnerLabel


func _ready() -> void:
	load_entries()


func save_entries() -> void:
	var save_data = SaveData.new()

	save_data.active.clear()
	save_data.inactive.clear()

	print("saving...")

	for entry in active:
		save_data.active.append(entry.text)
		print()

	for entry in inactive:
		save_data.inactive.append(entry.text)

	print("Active: ", save_data.active)
	print("Inactive: ", save_data.inactive)

	ResourceSaver.save("user://save.tres", save_data)


func load_entries() -> void:
	var save_data := load("user://save.tres") as SaveData

	if not save_data:

		for alias in DEFAULT:
			add_inactive_entry(alias)

	else:
		for alias in save_data.inactive:
			add_inactive_entry(alias)

		for alias in save_data.active:
			add_active_entry(alias)


func add_inactive_entry(alias: String) -> void:
	var entry := Entry.instance() as Entry

	entry.text = alias
	entry.connect("text_button_pressed", self, "_on_entry_text_pressed")
	entry.connect("remove_button_pressed", self, "_on_entry_remove_pressed")

	entries.append(entry)
	inactive.append(entry)

	inactive_container.add_child(entry)


func add_active_entry(alias: String) -> void:
	var entry := Entry.instance() as Entry

	entry.text = alias
	entry.connect("text_button_pressed", self, "_on_entry_text_pressed")
	entry.connect("remove_button_pressed", self, "_on_entry_remove_pressed")

	entries.append(entry)
	active.append(entry)

	active_container.add_child(entry)


func _on_StandupPicker_tree_exiting() -> void:
	save_entries()


func _on_AddEntry_entry_added(alias: String) -> void:
	add_inactive_entry(alias)


func _on_entry_text_pressed(entry: Entry) -> void:
	if inactive.has(entry):
		inactive_container.remove_child(entry)
		inactive.erase(entry)

		active_container.add_child(entry)
		active.append(entry)

	elif active.has(entry):
		active_container.remove_child(entry)
		active.erase(entry)

		inactive_container.add_child(entry)
		inactive.append(entry)


func _on_entry_remove_pressed(entry: Entry) -> void:
	entries.erase(entry)
	active.erase(entry)
	inactive.erase(entry)

	entry.queue_free()


func _on_LetsRoll_pressed() -> void:
	if not active:
		winner_label.text = ""
		return

	active.shuffle()
	var entry = active[0]
	winner_label.text = entry.text

	print("Picked ", winner_label.text, " From ", active.size())
