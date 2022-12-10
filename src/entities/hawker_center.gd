extends Entity
class_name HawkerCenter

var hawker_is_opened : bool = true
var closed : bool = false
var random_wait_time := 10
var current_wait_time = 100
var feedbacks := []

var open_at : TimeOnly = TimeOnly.new(6,0)
var close_at : TimeOnly = TimeOnly.new(23,00)
var next_day : DateTime

var table_manager : TableManager = TableManager.new()
var stall_manager : StallManager = StallManager.new()
var tray_station_manager : TrayStationManager = TrayStationManager.new()

onready var patron_manager : PatronManager = $PatronManager


func _ready() -> void:
	Log.log_error(Events.connect("hawker_center_changed", self, "_on_hawker_center_changed"))	
	Log.log_error(Events.connect("time_ellapsed", self, "_on_time_ellapsed"))
	Log.log_error(Events.connect("send_feedback", self, "on_feedback_sent"))
	Log.log_error(Events.connect("tally_screen_closed", self, "on_tally_screen_closed"))

	
func _on_time_ellapsed(date : DateTime) -> void:
	if not hawker_is_opened:
		# hawker is manually closed by user
		return

	if not Dates.in_time_only(date, open_at, close_at):
		if not closed:
			closed = true
			close_hawker(date)
		# hawker is closed for the night
		return
		
	closed = false

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


func on_tally_screen_closed() -> void:
	Events.emit_signal("clear_patrons_requested")

 
func close_hawker(date : DateTime) -> void:
	calculated_next_day(date)
	Events.emit_signal("pause_simulation", true)	
	Global.patron_manager.all_patrons_leave()
	Events.emit_signal("tally_screen_requested", {
		"date" : date,
		"total_patrons" : patron_manager.total_patrons_counts,
		"max_patrons" : patron_manager.max_patron_counts
	}) 


func calculated_next_day(date : DateTime) -> void:
	var week = date.week
	var next_day_nu = date.day + 1
	if next_day_nu > 6:
		next_day_nu = 0
		week += 1
	var ticks = open_at.ticks
	ticks += (week - 1) * Dates.TICKS_PER_WEEK + next_day_nu * Dates.MINUTES_PER_DAY
	next_day = Dates.get_date_from_ticks(ticks)


func start_new_day() -> void:
	if next_day == null:
		next_day = Global.current_datetime
	Events.emit_signal("update_current_datetime", next_day)
	Events.emit_signal("pause_simulation", false)
