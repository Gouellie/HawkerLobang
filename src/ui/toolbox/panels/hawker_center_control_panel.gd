extends ToolboxPanel

onready var open_center_button = $CenterContainer/MarginContainer/VBoxContainer/Button_OpenCloseCenter

func load_entity(entity : Entity) -> bool:
	selected_entity = entity
	if entity is HawkerCenter:
		return true
	return false


func unload_entity() -> void:
	.unload_entity()


func _on_Button_OpenAllStalls_pressed() -> void:
	Events.emit_signal("open_close_all_stalls", true)


func _on_Button_CloseAllStalls_pressed() -> void:
	Events.emit_signal("open_close_all_stalls", false)


func _on_Button_OpenCloseCenter_toggled(open: bool) -> void:
	Events.emit_signal("hawker_center_changed", open)
	open_center_button.text = "Close Center" if open else "Open Center"
