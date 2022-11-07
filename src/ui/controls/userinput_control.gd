extends Control

signal user_selection(accepted, text)

export var text : String

onready var line_edit : LineEdit = $VBoxContainer/LineEdit


func _ready() -> void:
	line_edit.text = text
	

func _on_Button_Accept_pressed() -> void:
	emit_signal("user_selection", true, line_edit.text)
	queue_free()


func _on_Button_Cancel_pressed() -> void:
	emit_signal("user_selection", false, "")
	queue_free()

