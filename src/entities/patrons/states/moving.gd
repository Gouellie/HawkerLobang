extends State

var nav_agent : NavigationAgent2D
var velocity : Vector2

export var nav_agent_radius : float = 5.0
export var nav_optimize_path : bool = false
export var nav_avoidance_enabled : bool = true
export var character_speed_multiplier : float = 6

onready var initial_character_speed_multiplier : int = character_speed_multiplier


# final navigation destination position/point
var nav_destination : Vector2 
# next navigation destination position/point
var next_nav_position : Vector2 

# The normal path to the destination
var character_nav_path : Array = []

# The actual path being calcuated during travel, used in the draw function
var character_real_nav_path : Array = []


func _ready() -> void:
	velocity = Vector2.ZERO 	
	nav_agent = $"../../NavigationAgent2D"
	nav_destination = global_position
	
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
	nav_agent.radius = nav_agent_radius
	nav_agent.avoidance_enabled = nav_avoidance_enabled

	set_navigation_position(nav_destination)


func enter(_msg: Dictionary = {}) -> void:
	on_speed_changed(Global.current_speed)
#	yield(get_tree().create_timer(1), "timeout")
	_state_machine.transition_to("Moving/Browsing")


func exit() -> void:
	pass


func set_navigation_position(nav_position_to_set : Vector2) -> void:
	nav_destination = nav_position_to_set
	# set the new character target location
	nav_agent.set_target_location(nav_destination)
	# calculate a new map path with the server using character nav agent map and new nav destination
	character_nav_path = Navigation2DServer.map_get_path(nav_agent.get_navigation_map(), global_position, nav_destination, nav_optimize_path)
	# clear the old real nav path, used for draw function
	character_real_nav_path.clear()


func on_speed_changed(speed : int) -> void:
	if speed < 0:
		speed = 20
	character_speed_multiplier = initial_character_speed_multiplier * speed


func on_time_ellapsed(_time : DateTime) -> void:
	pass
	

func physics_process(_delta: float) -> void:
	if nav_agent.is_target_reached():
		return
	next_nav_position = nav_agent.get_next_location()
	if owner.skin is Sprite:
		owner.skin.rotation = get_angle_to(next_nav_position)
	var desired_velocity = global_position.direction_to(next_nav_position) * character_speed_multiplier	
	if nav_avoidance_enabled:
		nav_agent.set_velocity(desired_velocity)
	else:
		velocity = owner.move_and_slide(desired_velocity)
		

func character_path_changed() -> void:
	# TODO, implement this function to add behavior for character
	pass
	
	
func character_target_reached() -> void:
	if _state_machine.state == self:
		return
	if _state_machine.state.has_method("character_target_reached"):
		_state_machine.state.character_target_reached()

	
func character_navigation_finished() -> void:
	# TODO, implement this function to add behavior for character
	pass
	
	
func character_velocity_computed(calculated_velocity : Vector2) -> void:
	if nav_agent.is_target_reached():
		return
	if owner is KinematicBody2D:
		velocity = owner.move_and_slide(calculated_velocity)

