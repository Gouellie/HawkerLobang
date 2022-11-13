extends Control


func _on_Button_Save_pressed() -> void:
	SaveFile.save_game()


func _on_Button_Exit_pressed() -> void:
	var err = get_tree().change_scene("res://src/screens/main_menu.tscn")
	if err != OK:
		Log.log_error(err)
