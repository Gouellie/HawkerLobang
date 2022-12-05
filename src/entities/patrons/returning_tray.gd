extends State

var table : Table
var station : TrayStation
var owner_area_2d : Area2D


func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "returning tray"
	table = msg["table"]
	station  = Global.tray_station_manager.get_nearest_station(owner.global_position)
	table.patron_leave_position(owner.sit_index, station != null)
	if station:
		owner.skin_tray.visible = true
		owner_area_2d = owner.stall_detector
		_parent.set_navigation_position(station.global_position)	
		_check_if_already_in_range()		
	else:
		_state_machine.transition_to("Moving/Leaving")


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func _check_if_already_in_range() -> void:
	if owner_area_2d is Area2D:
		if owner_area_2d.overlaps_area(station.station_range):
			# todo, check for proper index
			on_Area2D_body_entered(station, 0)

	
func on_Area2D_body_entered(body: Node2D, _area_shape_index: int) -> void:
	if body == station :
		_parent.set_navigation_position(station.get_next_position())	
		

func character_target_reached() -> void:
	owner.skin_tray.visible = false
	_state_machine.transition_to("Moving/Leaving")
