extends Control

signal selection_made(selection)

onready var stall_name :  = $CanvasLayer/CenterContainer/VBoxContainer/LineEdit_StallName
onready var drop_down : OptionButton = $CanvasLayer/CenterContainer/VBoxContainer/OptionButton


func _ready() -> void:
	stall_name.text = "Ayam Penyet"
	drop_down.align = Button.ALIGN_CENTER
	_add_items()


func _add_items() -> void:
	for stall in Resources.STALLS:
		drop_down.add_item(stall)


func _on_ButtonCancel_pressed() -> void:
	emit_signal("selection_made")
	queue_free()


func _on_ButtonAccept_pressed() -> void:
	var selection = {
		"stall" : drop_down.get_item_text(drop_down.selected),
		"name" : stall_name.text
	}
	emit_signal("selection_made", selection)
	queue_free()
