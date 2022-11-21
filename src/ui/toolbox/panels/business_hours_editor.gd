extends ToolboxPanel

const timespan_control = preload("res://src/ui/controls/timespan_control.tscn")

const MAX_COUNT : int = 8

var _business_hours : BusinessHours

onready var timespans : VBoxContainer = $Control/Timespans
onready var timespan_bulk := $CenterContainer/HBoxContainer/TimeSpanItem_Bulk


func _ready() -> void:
	Log.log_error(timespan_bulk.connect("apply_changes", self, "_apply_changes_bulk"))


func load_entity(entity : Entity) -> bool:
	if entity is Stall and entity.business_hours:
		_business_hours = entity.business_hours
		_populate_timespan()
		return not entity.is_stall_vacant
	return false


func unload_entity() -> void:
	for timespan in timespans.get_children():
		timespan.queue_free()
	_business_hours = null


func _populate_timespan() -> void:
	if _business_hours == null:
		return
	for timespan in _business_hours.business_hours:
		_add_new_entry(timespan)


func _on_Button_Add_pressed() -> void:
	if timespans.get_child_count() >= MAX_COUNT:
		return
	var new_date = Dates.generate_date(0, 8, 0)
	var new_timespan = Dates.generate_timespan_elapsed(new_date, 0, 8, 0)
	_business_hours.business_hours.append(new_timespan)
	_add_new_entry(new_timespan)


func _add_new_entry(p_timespan : TimeSpan) -> void:
	var new_timespan_control = timespan_control.instance()
	new_timespan_control.timespan = p_timespan
	new_timespan_control.connect("entry_deleted", self, "_on_entry_deleted")
	timespans.add_child(new_timespan_control)
	

func _on_entry_deleted(timespan : TimeSpan) -> void:
	_business_hours.business_hours.erase(timespan)


func _apply_changes_bulk(p_timespan_bulk : TimeSpan) -> void:
	for timespan in timespans.get_children():
		timespan.update_timespan(p_timespan_bulk)

