extends Node

var current_datetime : DateTime setget set_curent_datetime,get_curent_datetime
var entity_tracker : EntityTracker setget set_entity_tracker,get_entity_tracker
var builder_mode_on : bool setget ,_get_builder_mode_on
var patrons_count : int = 0

var current_speed : int = 1

func _ready() -> void:
	Log.log_error(Events.connect("blueprint_selected", self, "_on_blueprint_selected"), "global.gd")


func _reset() -> void:
	current_datetime = null
	entity_tracker = null
	builder_mode_on = false
	patrons_count = 0
	current_speed = 1


func set_curent_datetime(date : DateTime) -> void:
	current_datetime = date
	

func get_curent_datetime() -> DateTime:
	if current_datetime:
		return Dates.copy_datetime(current_datetime) 
	return Dates.get_new_date()


func set_entity_tracker(tracker : EntityTracker) -> void:
	entity_tracker = tracker
	

func get_entity_tracker() -> EntityTracker:
	return entity_tracker

	
func _on_blueprint_selected(sender)-> void:
	builder_mode_on = sender != null
	
	
func _get_builder_mode_on() -> bool:
	return builder_mode_on


func set_patrons_count(count : int) -> void:
	patrons_count = count
	Events.emit_signal("patron_count_changed", count)		
	
	
func get_patrons_count() -> int:
	return patrons_count
