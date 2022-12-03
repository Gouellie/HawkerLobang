extends Control

var feedback : Feedback

signal entry_deleted(entry)

onready var label : Label = $MarginContainer/HBoxContainer/Panel/MarginContainer/Label
onready var color_rect := $ColorRect


func _ready() -> void:
	assert(feedback, "feedback cannot be null")
	color_rect.visible = false	
	label.text = feedback.message


func _on_FeedbackControl_mouse_entered() -> void:
	color_rect.visible = true


func _on_FeedbackControl_mouse_exited() -> void:
	color_rect.visible = false


func _on_Button_DeleteEntry_pressed() -> void:
	emit_signal("entry_deleted", self)
