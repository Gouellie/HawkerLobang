extends CanvasLayer

onready var file_dialog : FileDialog = $FileDialog

onready var button_load : Button = $VBoxContainer/Button_Load

func _ready() -> void:
	button_load.disabled = not SaveFile.save_file_found()
	

func _on_Button_New_pressed() -> void:
	SaveFile.new_game()
	var err = get_tree().change_scene("res://src/scenes/hawker_scene.tscn")
	Log.log_error(err, "main_menu.gd")


func _on_Button_Load_pressed() -> void:
	file_dialog.current_dir = SaveFile.SAVE_FILE_DIR
	file_dialog.popup_centered()


func _on_Button_Sandbox_pressed() -> void:
	var err = get_tree().change_scene("res://src/scenes/sandbox.tscn")
	Log.log_error(err, "main_menu.gd")


func _on_Button_Quit_pressed() -> void:
	get_tree().quit()


func _on_FileDialog_file_selected(path: String) -> void:
	SaveFile.load_game(path)
	var err = get_tree().change_scene("res://src/scenes/hawker_scene.tscn")
	Log.log_error(err, "main_menu.gd")
