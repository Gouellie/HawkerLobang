extends CanvasLayer


func _on_Button_New_pressed() -> void:
	SaveFile.create_new()
	var err = get_tree().change_scene("res://src/scenes/hawker_scene.tscn")
	if err != OK:
		Log.log_error(err)


func _on_Button_Load_pressed() -> void:
	SaveFile.load_data()
	var err = get_tree().change_scene("res://src/scenes/hawker_scene.tscn")
	if err != OK:
		Log.log_error(err)


func _on_Button_Sandbox_pressed() -> void:
	var err = get_tree().change_scene("res://src/scenes/sandbox.tscn")
	if err != OK:
		Log.log_error(err)


func _on_Button_Quit_pressed() -> void:
	get_tree().quit()


