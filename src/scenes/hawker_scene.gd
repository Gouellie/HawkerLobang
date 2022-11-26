extends Node2D

var hawker_is_opened : bool = true
var random_wait_time := 10
var current_wait_time = 0

onready var _entity_manager = $EntityManager


func _ready() -> void:
	Log.log_error(Events.connect("hawker_center_changed", self, "_on_hawker_center_changed"))	
	Log.log_error(Events.connect("time_ellapsed", self, "_on_time_ellapsed"))
	
	
func _on_time_ellapsed(_date) -> void:
	if not hawker_is_opened:
		return
	current_wait_time += 1
	if current_wait_time < random_wait_time:
		return
	current_wait_time = 0
	random_wait_time = randi() % 3 + 3
	Events.emit_signal("patron_invoked")


func _on_hawker_center_changed(open : bool) -> void:
	hawker_is_opened = open
	if hawker_is_opened :
		Log.log_error(Events.connect("time_ellapsed", self, "_on_time_ellapsed"))
	else:
		Events.disconnect("time_ellapsed", self, "_on_time_ellapsed")
