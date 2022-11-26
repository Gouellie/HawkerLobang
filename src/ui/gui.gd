extends Control

onready var toolbox : Control = $Toolbox_Container/Toolbox
onready var save_file_dialog : FileDialog = $SaveFileDialog
onready var options_container := $HBoxContainer_Options/VBoxContainer/Container_Options
onready var label_patrons := $HBoxContainer/Control/InfoControl/Label_Patrons


func _ready() -> void:
	Log.log_error(Events.connect("entity_selected", self, "_on_entity_selected"), "gui.gd")
	Log.log_error(Events.connect("patron_count_changed", self, "_on_patron_count_changed"))
	_on_patron_count_changed(Global.get_patrons_count())


func _on_Button_Save_pressed() -> void:
	SaveFile.save_game()


func _on_Button_SaveAs_pressed() -> void:
	save_file_dialog.current_dir = SaveFile.SAVE_FILE_DIR
	save_file_dialog.current_file = "SaveFile.save"
	save_file_dialog.popup_centered()


func _on_Button_Exit_pressed() -> void:
	var err = get_tree().change_scene("res://src/screens/main_menu.tscn")
	if err != OK:
		Log.log_error(err)


func _on_entity_selected(_selected_entity : Node2D) -> void:
	if _selected_entity == null:
		return
	
	# todo, remove
	if _selected_entity is Patron:
		return
		
	toolbox.load_setup(_selected_entity)
	toolbox.visible = true


func _on_patron_count_changed(count : int) -> void:
	label_patrons.text = "Patrons : %d" % count 


func _on_SaveFileDialog_file_selected(path: String) -> void:
	SaveFile.save_game(path)


func _on_Button_Options_pressed() -> void:
	var visible = options_container.visible
	options_container.visible = not visible
	if visible :
		$HBoxContainer_Options/VBoxContainer/Button_Options.text = "Expand"
	else:
		$HBoxContainer_Options/VBoxContainer/Button_Options.text = "Collapse"


func _on_Button_ClearPatrons_pressed() -> void:
	Events.emit_signal("clear_patrons_requested")


func _on_Button_InvokePatron_pressed() -> void:
	Events.emit_signal("patron_invoked")
