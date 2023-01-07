extends Control

export (NodePath) var hawker_center_path

onready var save_file_dialog : FileDialog = $SaveFileDialog
onready var options_container := $HBoxContainer_Options/VBoxContainer/Container_Options


func _ready() -> void:
	assert(!hawker_center_path.is_empty(), "hawker center path cannot be empty")
	$HawkerControl.hawker_center = get_node(hawker_center_path)


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


func _on_SaveFileDialog_file_selected(path: String) -> void:
	SaveFile.save_game(path)


func _on_Button_Options_pressed() -> void:
	var visible = options_container.visible
	options_container.visible = not visible
	if visible :
		$HBoxContainer_Options/VBoxContainer/Button_Options.text = "Expand"
	else:
		$HBoxContainer_Options/VBoxContainer/Button_Options.text = "Collapse"
