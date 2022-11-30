extends State

var table : Table

var time_to_eat : int = 12
var time_eating : int = 0
var done_eating : bool


var patron_group : Array


func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "eating"	
	table = msg["table"]
	if not is_instance_valid(table):
		leave()
	time_eating = 0
	done_eating = false
	if owner.is_group_leader:
		patron_group = Global.patron_manager.get_patron_group(owner)


func exit() -> void:
	pass


func on_time_ellapsed(_dateTime : DateTime) -> void:
	if not done_eating:
		time_eating += 1
		if time_eating >= time_to_eat :
			done_eating = true
			owner.ready_to_leave = true
	else:
		_validate_ready_to_leave()


func _validate_ready_to_leave() -> void:
	if Global.patron_manager.is_group_ready_to_leave(owner):
		leave()


func leave() -> void:
	_state_machine.transition_to("Moving/Leaving")

