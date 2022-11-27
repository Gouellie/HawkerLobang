extends Node2D

var hawker_is_opened : bool = true
var random_wait_time := 10
var current_wait_time = 0

var open_at : TimeOnly = TimeOnly.new(5, 0)
var close_at : TimeOnly = TimeOnly.new(22,30)

onready var _entity_manager = $EntityManager


func _ready() -> void:
	Log.log_error(Events.connect("hawker_center_changed", self, "_on_hawker_center_changed"))	
	Log.log_error(Events.connect("time_ellapsed", self, "_on_time_ellapsed"))
	
	
func _on_time_ellapsed(date) -> void:
	if not hawker_is_opened:
		return
	if not Dates.in_time_only(date, open_at, close_at):
		# hawker is closed for the night
		return
	if Global.patrons_count >= 300:
		return
	current_wait_time += 1
	if current_wait_time < random_wait_time:
		return
	var mod = _get_time_of_day_modifier(date)
	current_wait_time = 0
	random_wait_time = randi() % 12 - mod
	Events.emit_signal("patron_invoked")


func _on_hawker_center_changed(open : bool) -> void:
	hawker_is_opened = open
	if hawker_is_opened :
		Log.log_error(Events.connect("time_ellapsed", self, "_on_time_ellapsed"))
	else:
		Events.disconnect("time_ellapsed", self, "_on_time_ellapsed")
		

func _get_time_of_day_modifier(date : DateTime) -> float:
	var hourf = date.hour + date.minute / 60.0
	return (cos(hourf - 0.8) + 1.1) * 4

