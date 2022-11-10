extends Node

var builder_mode_on : bool setget ,_get_builder_mode_on

func _ready() -> void:
	Log.log_error(Events.connect("blueprint_selected", self, "_on_blueprint_selected"), "global.gd")


func _reset() -> void:
	builder_mode_on = false
	
	
func _on_blueprint_selected(sender)-> void:
	builder_mode_on = sender != null
	
	
func _get_builder_mode_on() -> bool:
	return builder_mode_on
