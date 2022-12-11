extends State


func enter(_msg: Dictionary = {}) -> void:
	var exit = Global.entrance_manager.get_entrance()
	_parent.set_navigation_position(exit)


func exit() -> void:
	pass


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func character_target_reached() -> void:
	owner.skin.visible = false
