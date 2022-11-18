extends ToolboxPanel

onready var label_opened_since : Label = $Label_OpenedSince

func load_entity(_entity : Entity) -> bool:
	selected_entity = _entity
	if _entity is Stall:
		update_label(_entity)
		return not _entity.is_stall_vacant
	return false


func unload_entity() -> void:
	.unload_entity()


func _on_Button_CloseStall_pressed() -> void:
	if selected_entity is Stall:
		selected_entity.close_stall()


func update_label(stall : Stall) -> void:
	if stall.is_stall_vacant:
		return
	if not label_opened_since:
		return
	var label_text = "Opened Since : %s"
	label_opened_since.text = label_text % stall.date_of_opening.to_string()
