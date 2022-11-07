extends CanvasLayer

signal selection_made(container)

const timespan_control = preload("res://src/UI/Controls/timespan_control.tscn")

const MAX_COUNT : int = 8

export (bool) var debug 

export (String) var stall_name
export (String) var dish_type
var  business_hours : Array

onready var timespans : VBoxContainer = $Control/Timespans
onready var label_stall_name := $Control/Label_Stall_Name
onready var timespan_bulk := $Control/HBoxContainer/TimeSpanItem_Bulk


func _ready() -> void:
	if debug:
		_debug_setup()
	assert(business_hours, "ERROR : business_hours cannot be null")
	label_stall_name.text = "%s : %s" % [stall_name, dish_type]
	var err = timespan_bulk.connect("apply_changes", self, "_apply_changes_bulk")
	if err != OK:
		print("ERROR : business_hours_editor : _ready() : connecting to timespan_bulk failed with error : %s", err)
	_populate_timespan()


func _debug_setup() -> void:
	print("WARNING : business_hours_editor is using debug mode")	
	stall_name = "Selera Rasa"
	dish_type = "Nasi Lemak"
	business_hours =  []
	for day in range(1,6):
		var span = Dates.generate_timespan(day, 8, 0, day, 21, 0)
		business_hours.append(span)


func _populate_timespan() -> void:
	if business_hours == null:
		return
	for timespan in business_hours:
		_add_new_entry(timespan)


func _add_new_entry(p_timespan : TimeSpan) -> void:
	var new_timespan_control = timespan_control.instance()
	new_timespan_control.timespan = p_timespan
	new_timespan_control.connect("entry_deleted", self, "_on_entry_deleted")
	timespans.add_child(new_timespan_control)


func _on_Button_Close_pressed() -> void:
	emit_signal("selection_made", null)
	queue_free()


func _on_Button_Accept_pressed() -> void:
	emit_signal("selection_made", business_hours)
	queue_free()


func _on_Button_Add_pressed() -> void:
	if timespans.get_child_count() >= MAX_COUNT:
		return
	var new_date = Dates.generate_date(0, 8, 0)
	var new_timespan = Dates.generate_timespan(new_date, 0, 8, 0)
	business_hours.append(new_timespan)
	_add_new_entry(new_timespan)


func _on_entry_deleted(timespan : TimeSpan) -> void:
	business_hours.erase(timespan)


func _apply_changes_bulk(p_timespan_bulk : TimeSpan) -> void:
	for timespan in timespans.get_children():
		timespan.update_timespan(p_timespan_bulk)

