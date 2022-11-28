extends Control

onready var _tab_container : TabContainer = $TabContainer
onready var _label_text : Label = $CenterContainer/Label
onready var _stall_creator : ToolboxPanel = $TabContainer/Open/StallCreator
onready var _info_panel : ToolboxPanel = $TabContainer/Info/InfoPanel
onready var _business_hours_editor : ToolboxPanel = $"TabContainer/Business Hours/BusinessHoursEditor"
var _selected_entity : Entity


func load_setup(p_selected_entity : Entity) -> void:
	var current_tab = _tab_container.current_tab
	if _selected_entity :
		_unload_entity()
	_selected_entity = p_selected_entity
	var creator_active = _stall_creator.load_entity(_selected_entity)
	_tab_container.set_tab_hidden(0, not creator_active)
	var info_panel_active = _info_panel.load_entity(_selected_entity)
	_tab_container.set_tab_hidden(1, not info_panel_active)	
	var business_hours_active = _business_hours_editor.load_entity(_selected_entity)
	_tab_container.set_tab_hidden(2, not business_hours_active)
	_set_label_text(_selected_entity)
	if not _tab_container.get_tab_hidden(current_tab):
		_tab_container.current_tab = current_tab
		
	Global.is_toolbox_open = true
	visible = true


func _set_label_text(_entity : Entity) -> void:
	if _entity is Stall:
		_label_text.text = "%s : %s" % [_entity.stall_name, _entity.dish_name]


func _on_Button_ClosePanel_pressed() -> void:
	Global.is_toolbox_open = false
	visible = false
	_unload_entity()
	

func _unload_entity() -> void:
	_info_panel.unload_entity()
	_stall_creator.unload_entity()
	_business_hours_editor.unload_entity()
	_selected_entity = null
