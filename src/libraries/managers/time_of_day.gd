extends Node

const TOD_DEFAULT_TICK : float = 1.0

var datetime : DateTime
var _current_speed : int = 1
var _skip_ticker : bool

onready var ticker : Timer = $Ticker


func _ready() -> void:
	Log.log_error(Events.connect("speed_changed", self, "_on_speed_changed"), "time_of_day.gd")
	Log.log_error(Events.connect("save_game", self, "_save_pressed"), "time_of_day.gd")
	datetime = Dates.from_dictionary(SaveFile.game_data[SaveFile.DATE_KEY])
	ticker.start()


func _process(_delta: float) -> void:
	if _skip_ticker :
		_increment_date()


func _on_Ticker_timeout() -> void:
	_increment_date()


func _increment_date() -> void:
	datetime.increment()	
	Events.emit_signal("time_ellapsed", datetime)


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


func _save_pressed() -> void:
	SaveFile.game_data[SaveFile.DATE_KEY] = Dates.to_dictionary(datetime)

