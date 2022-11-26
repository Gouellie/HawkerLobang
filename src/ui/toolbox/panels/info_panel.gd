extends ToolboxPanel

onready var label_opened_since : Label = $Label_OpenedSince

onready var button_always_open : Button = $MarginContainer/Control/Button_AlwaysOpen

onready var button_close : Button = $MarginContainer/Control/Button_Close

func load_entity(entity : Entity) -> bool:
	selected_entity = entity
	if entity is Stall:
		update_label(entity)
		_show_control_button(entity.is_always_open)
		return not entity.is_stall_vacant
	return false


func unload_entity() -> void:
	.unload_entity()


func _show_control_button(toggle : bool) -> void:
	button_always_open.visible = not toggle
	button_close.visible = toggle


func _on_Button_AlwaysOpen_pressed() -> void:
	if selected_entity is Stall:
		selected_entity.always_open(true)
		_show_control_button(true)
		

func _on_Button_CloseStall_pressed() -> void:
	if selected_entity is Stall:
		selected_entity.close_stall()
		_show_control_button(false)		


func _on_Button_Vacate_pressed() -> void:
	if selected_entity is Stall:
		selected_entity.vacate_stall()


func update_label(stall : Stall) -> void:
	if stall.is_stall_vacant:
		return
	if not label_opened_since:
		return
	var label_text = "Opened Since : %s"
	label_opened_since.text = label_text % stall.date_of_opening.to_string()
