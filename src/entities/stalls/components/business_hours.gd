extends Node2D

var business_hours_editor = preload("res://src/ui/business_hours_editor.tscn")

var business_hours := []

func _ready() -> void:
	for day in range(1,6):
		var span = Dates.generate_timespan(day, 8, 0, day, 20, 0)
		business_hours.append(span)


func in_business_hour(date : DateTime) -> bool:
	for timespan in business_hours:
		if timespan.in_span(date):
			return true
	return false


func edit_business_hours() -> void:
	var editor = business_hours_editor.instance()
	editor.stall_name = owner.stall_name
	editor.dish_type = owner.dish_name
	editor.business_hours = _copy_business_hours()
	get_tree().root.add_child(editor)
	
	var selection = yield(editor, "selection_made")
	if selection == null:
		return
	business_hours = selection


func _copy_business_hours() -> Array:
	var business_hours_copy = []
	for timespan in business_hours:
		business_hours_copy.append(Dates.copy_timespan(timespan))
	return business_hours_copy
