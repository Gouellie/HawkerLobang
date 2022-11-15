extends Control


onready var toolbox : Control = $Toolbox_Container/Toolbox


func _ready() -> void:
	Log.log_error(Events.connect("entity_selected", self, "_on_entity_selected"), "gui.gd")


func _on_Button_Save_pressed() -> void:
	SaveFile.save_game()


func _on_Button_Exit_pressed() -> void:
	var err = get_tree().change_scene("res://src/screens/main_menu.tscn")
	if err != OK:
		Log.log_error(err)


func _on_entity_selected(_selected_entity : Node2D) -> void:
	if _selected_entity == null:
		return
	toolbox.load_setup(_selected_entity)
	toolbox.visible = true
