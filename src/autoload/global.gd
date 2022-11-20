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
	

var current_datetime : DateTime setget set_curent_datetime,get_curent_datetime


func set_curent_datetime(date : DateTime) -> void:
	current_datetime = date
	

func get_curent_datetime() -> DateTime:
	if current_datetime:
		return Dates.copy_datetime(current_datetime) 
	return Dates.get_new_date()
	

var entity_tracker : EntityTracker setget set_entity_tracker,get_entity_tracker


func set_entity_tracker(tracker : EntityTracker) -> void:
	entity_tracker = tracker
	

func get_entity_tracker() -> EntityTracker:
	return entity_tracker

