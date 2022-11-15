extends ToolboxPanel


func load_entity(_entity : Entity) -> bool:
	selected_entity = _entity
	if _entity is Stall:
		return not _entity.is_stall_vacant
	return false


func unload_entity() -> void:
	.unload_entity()


func _on_Button_CloseStall_pressed() -> void:
	if selected_entity is Stall:
		selected_entity.close_stall()
