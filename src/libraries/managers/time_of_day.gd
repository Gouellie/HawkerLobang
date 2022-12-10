extends Node

const TOD_DEFAULT_TICK : float = 1.0

var datetime : DateTime = Dates.generate_date(1, 6, 0)

var simulation_paused : bool = true
var _current_speed : int = 1
var _skip_ticker : bool

onready var ticker : Timer = $Ticker


func _ready() -> void:
	_load()
	Log.log_error(Events.connect("pause_simulation", self, "pause_simulation"))
	Log.log_error(Events.connect("speed_changed", self, "_on_speed_changed"))
	Log.log_error(Events.connect("update_current_datetime", self, "on_current_datetime_updated"))
	Global.current_datetime = datetime
	Events.emit_signal("time_ellapsed", datetime)
	ticker.start()


func _process(_delta: float) -> void:
	if _skip_ticker :
		_increment_date()


func _on_Ticker_timeout() -> void:
	if simulation_paused:
#		Events.emit_signal("time_ellapsed", datetime)
		return
	_increment_date()


func _increment_date() -> void:
	datetime.increment()
	Events.emit_signal("time_ellapsed", datetime)


func pause_simulation(paused : bool) -> void:
	simulation_paused = paused
	# todo, allow for tick speed to max


func _on_speed_changed(p_speed : int) -> void:
	_current_speed = p_speed
	_skip_ticker = false
	if p_speed == 0:
		ticker.stop()
	elif p_speed > 0:
		ticker.wait_time = TOD_DEFAULT_TICK / p_speed
		ticker.start()
	else:
		ticker.stop()		
		# updating with _process instead of timer
		_skip_ticker = true


func on_current_datetime_updated(p_current : DateTime) -> void:
	datetime.update_date(p_current)
	Events.emit_signal("time_ellapsed", datetime)


func _load() -> void:
	if SaveFile.game_data.has("date"):
		var ticks = SaveFile.game_data["date"]
		datetime.from_ticks(ticks)


func save() -> Dictionary:
	return {
		"date" : datetime.ticks
	}


func reload(data : Dictionary) -> void:
	if data.has("date"):
		var ticks = data["date"]
		datetime.from_ticks(ticks)
		Events.emit_signal("time_ellapsed", datetime)	
