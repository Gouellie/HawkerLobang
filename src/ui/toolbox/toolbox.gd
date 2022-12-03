extends Control

onready var _tab_container : TabContainer = $TabContainer
onready var _label_text : Label = $CenterContainer/Label
onready var _toobox_panels := []

var _selected_entity : Entity


func _ready() -> void:
	Log.log_error(Events.connect("entity_selected", self, "on_entity_selected"), "toolbox.gd")
	for tab in $TabContainer.get_children():
		_toobox_panels.append(tab.get_child(0))


func on_entity_selected(p_selected_entity : Entity) -> void:
	if p_selected_entity == null:
		return
	if not p_selected_entity.open_toolbox():
		return
	if _selected_entity == p_selected_entity:
		if p_selected_entity is HawkerCenter:
			_set_panel_visible(false)
			_unload_entity()
			return

	_load_entity(p_selected_entity)


func _load_entity(p_selected_entity : Entity) -> void:
	var current_tab = _tab_container.current_tab
	if _selected_entity :
		_unload_entity()
	_selected_entity = p_selected_entity
	
	var current = 0
	for panel in _toobox_panels:
		var panel_active = panel.load_entity(_selected_entity)
		_tab_container.set_tab_hidden(current, not panel_active)
		current += 1

	if not _tab_container.get_tab_hidden(current_tab):
		_tab_container.current_tab = current_tab

	_set_label_text(_selected_entity)
	_set_panel_visible(true)


func _set_label_text(_entity : Entity) -> void:
	_label_text.text = _entity.get_toolbox_display_name()


func _on_Button_ClosePanel_pressed() -> void:
	_set_panel_visible(false)
	_unload_entity()


func _unload_entity() -> void:
	for panel in _toobox_panels:
		panel.unload_entity()
	_selected_entity = null


func _set_panel_visible(value : bool) -> void:
	Global.is_toolbox_open = value
	visible = value	
