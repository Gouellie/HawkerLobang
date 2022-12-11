extends State

var nav_agent : NavigationAgent2D
var velocity : Vector2

const nav_agent_max_speed : float = 200.0
const nav_agent_radius : float = 1.0
const nav_optimize_path : bool = false
const nav_avoidance_enabled : bool = false
const initial_character_speed_multiplier : float = 10.0

var character_speed_multiplier : float = initial_character_speed_multiplier


func _ready() -> void:
	velocity = Vector2.ZERO 	
	nav_agent = $"../../NavigationAgent2D"
	
	# connect nav agent signal callback functions
	# warning-ignore:return_value_discarded
	nav_agent.connect("path_changed", self, "character_path_changed")
	# warning-ignore:return_value_discarded
	nav_agent.connect("target_reached", self, "character_target_reached")
	# warning-ignore:return_value_discarded
	nav_agent.connect("navigation_finished", self, "character_navigation_finished")
	# warning-ignore:return_value_discarded
	nav_agent.connect("velocity_computed", self, "character_velocity_computed")
	# config nav agent attributes
	nav_agent.max_speed = 120
	nav_agent.path_desired_distance = 2.0
	nav_agent.target_desired_distance = 2.0
	nav_agent.radius = nav_agent_radius
	nav_agent.avoidance_enabled = nav_avoidance_enabled

	set_navigation_position(global_position)


func enter(_msg: Dictionary = {}) -> void:
	set_navigation_speed(Global.current_speed)
	if owner.is_group_leader:
		_state_machine.transition_to("Moving/ChopeTable")
	else:
		_state_machine.transition_to("Moving/Browsing")


func exit() -> void:
	pass


func set_navigation_position(nav_position_to_set : Vector2) -> void:
	nav_agent.set_target_location(nav_position_to_set)


func set_navigation_speed(speed : int) -> void:
	character_speed_multiplier = initial_character_speed_multiplier * speed


func physics_process(_delta: float) -> void:
	var next_nav_position = nav_agent.get_next_location()
	if nav_agent.is_navigation_finished():
		return
	if owner.skin:
		owner.skin.rotation = get_angle_to(next_nav_position)

	var desired_velocity = global_position.direction_to(next_nav_position) * character_speed_multiplier	
	if nav_avoidance_enabled:
		nav_agent.set_velocity(desired_velocity)
	else:
		velocity = owner.move_and_slide(desired_velocity)

	
func character_velocity_computed(calculated_velocity : Vector2) -> void:
	if nav_agent.is_target_reached():
		return
	if owner is KinematicBody2D:
		velocity = owner.move_and_slide(calculated_velocity)


func character_path_changed() -> void:
	# do not delete, getting invoked by nav_agent and throw warnings if not found
	pass
	

func character_navigation_finished() -> void:
	# do not delete, getting invoked by nav_agent and throw warnings if not found
	pass	
	

func character_target_reached() -> void:
	if not _state_machine.state:
		return
	if _state_machine.state == self:
		return
	if _state_machine.state.has_method("character_target_reached"):
		_state_machine.state.character_target_reached()
