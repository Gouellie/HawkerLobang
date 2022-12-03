extends Entity
class_name HawkerCenter

var hawker_is_opened : bool = true
var random_wait_time := 10
var current_wait_time = 100
var feedbacks := []

var open_at : TimeOnly = TimeOnly.new(5, 0)
var close_at : TimeOnly = TimeOnly.new(22,30)

var table_manager : TableManager = TableManager.new()
var stall_manager : StallManager = StallManager.new()


func _ready() -> void:
	Log.log_error(Events.connect("hawker_center_changed", self, "_on_hawker_center_changed"))	
	Log.log_error(Events.connect("time_ellapsed", self, "_on_time_ellapsed"))
	Log.log_error(Events.connect("send_feedback", self, "on_feedback_sent"))

	
func _on_time_ellapsed(date) -> void:
	if not hawker_is_opened:
		# hawker is manually closed by user
		return

	if not Dates.in_time_only(date, open_at, close_at):
		# hawker is closed for the night
		return

	current_wait_time += 1
	if current_wait_time < random_wait_time:
		return

	var open_stall_count = stall_manager.get_open_stall_count()
	if open_stall_count < 1:
		return
	
	# todo replace by value that fluctuates with offer 
	if Global.patrons_count >= open_stall_count * 25:
		return
	
	var mod = _get_time_of_day_modifier(date)
	current_wait_time = 0
	random_wait_time = randi() % 12 - mod
	var groupsize = randi() % 4  + 1
	Events.emit_signal("patron_invoked", groupsize, false)


func _on_hawker_center_changed(open : bool) -> void:
	hawker_is_opened = open
	if hawker_is_opened :
		Log.log_error(Events.connect("time_ellapsed", self, "_on_time_ellapsed"))
	else:
		Events.disconnect("time_ellapsed", self, "_on_time_ellapsed")


func _get_time_of_day_modifier(date : DateTime) -> float:
	var hourf = date.hour + range_lerp(date.minute, 0, 60, 0, 1)
	return (cos(hourf - 0.8) + 1.1) * 4


func open_toolbox() -> bool:
	return true


func on_feedback_sent(feedback : Feedback) -> void:
	feedbacks.append(feedback)


func delete_feeback_entry(feedback : Feedback) -> void:
	feedbacks.erase(feedback)
	
	
func delete_feedbacks() -> void:
	feedbacks.clear()
