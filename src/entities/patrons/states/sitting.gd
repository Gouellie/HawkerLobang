extends State

var table : Table
var sitting_position : Vector2
var owner_skin : Sprite
var sitting_speed : int

func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "sitting down"	
	if not msg.has("table"):
		assert(null, "fix me")
	table = msg["table"]
	sitting_position = table.get_sitting_position(owner.sit_index)
	sitting_speed = Global.current_speed
	owner_skin = owner.skin


func on_speed_changed(speed : int) -> void:
	sitting_speed = speed


func exit() -> void:
	pass


func physics_process(_delta: float) -> void:
	owner.global_position = lerp(owner.global_position, sitting_position, 0.05 * sitting_speed)
	owner_skin.rotation = lerp_angle(owner_skin.rotation, table.rotation, 0.05 * sitting_speed)
	
#	if owner.global_position.is_equal_approx(sitting_position):
	if owner.global_position.distance_to(sitting_position) < 2.0:
		owner.global_position = sitting_position
		owner.skin.rotation = get_angle_to(table.global_position)
		_state_machine.transition_to("Idle/Eating", {
			"table" : table
		})
	

