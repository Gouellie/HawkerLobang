extends State

var time_to_eat : int = 12
var time_eating : int = 0

var table : Table

func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "eating"	
	if not msg.has("table"):
		assert(null, "fix me")
	table = msg["table"]
	time_eating = 0
	

func exit() -> void:
	table.patron_leave_table()


func on_time_ellapsed(_dateTime : DateTime) -> void:
	time_eating += 1
	
	if time_eating >= time_to_eat :
		_state_machine.transition_to("Moving/Leaving")

	

