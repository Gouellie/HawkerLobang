extends Node2D

class_name QueueManager

const MAX_QUEUE_LEN : int = 7
var offset := Vector2(15, 0)

var stall_is_open : bool
var queue := []
var queue_positions : PoolVector2Array


func _ready() -> void:
	Log.log_error(owner.connect("loaded", self, "on_owner_loaded"))
	Log.log_error(Events.connect("clear_patrons_requested", self, "_on_clear_patrons_requested"))		


func set_stall_open(open : bool) -> void:
	owner.is_open_for_business = open	
	stall_is_open = open
	if not open :
		break_queue()
	queue.clear()


func on_owner_loaded() -> void:
	_generate_queue_position()


func _generate_queue_position() -> void:
	offset = offset.rotated(owner.rotation)
	var queue_position = owner.queue_position as Vector2
	for i in range(MAX_QUEUE_LEN):
		queue_positions.push_back(queue_position + i * offset)


func can_join_queue() -> bool:
	return queue.size() < MAX_QUEUE_LEN


func patron_join_queue(patron : Patron) -> Dictionary:
	var result = {
		"success" : false,
		"pos" : Vector2.ZERO
	}
	if not stall_is_open:
		return result
	if queue.size() == MAX_QUEUE_LEN:
		return result
	var index = queue.find(patron)
	assert(index < 0, "ERROR : Patron is already in queue")
	queue.push_back(patron)
	result["success"] = true
	result["pos"] = queue_positions[queue.size()-1]
	return result
	
	
func get_next_patron() -> Patron:
	if queue.size() < 1:
		return null
	if not is_instance_valid(queue[0]):
		queue.pop_front()
		return null
	if not queue[0].is_patron_in_queue():
		return null
	var next_patron = queue.pop_front()
	notify_patron_queue_changed()
	return next_patron
	
	
func patron_break_queue(patron : Patron) -> void:
	var index = queue.find(patron)
	if index < 0: # patron not in queue
		return
	queue.pop_at(index)
	notify_patron_queue_changed(index)


func break_queue() -> void:
	for patron in queue:
		if not is_instance_valid(patron):
			continue
		if patron is Patron:
			patron.break_queue()
	queue.clear()
	

func notify_patron_queue_changed(from_index : int = 0) -> void:
	var queue_range = from_index if from_index > 0 else queue.size()
	for i in range(queue_range):
		var patron = queue[i]
		if is_instance_valid(patron) and patron is Patron:
			patron.update_position_in_queue(queue_positions[i])


func _on_clear_patrons_requested() -> void:
	queue.clear()
