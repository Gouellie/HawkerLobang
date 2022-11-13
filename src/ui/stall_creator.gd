extends Control

signal selection_made(selection)

onready var stall_name :  = $CanvasLayer/CenterContainer/Container/LineEdit_StallName
onready var drop_down : OptionButton = $CanvasLayer/CenterContainer/Container/OptionButton


func _ready() -> void:
	_add_items()
	drop_down.align = Button.ALIGN_CENTER
	var dish_name = drop_down.get_item_text(0)
	var generated_name = NameDispatcher.get_random_name(dish_name)
	stall_name.text = generated_name


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


func _on_OptionButton_item_selected(index: int) -> void:
	var dish_name = drop_down.get_item_text(index)
	var generated_name = NameDispatcher.get_random_name(dish_name)
	if generated_name == "":
		return
	stall_name.text = generated_name
