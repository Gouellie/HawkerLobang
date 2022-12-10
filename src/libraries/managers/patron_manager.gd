extends Node2D
class_name PatronManager

const patron_scene := preload("res://src/entities/patrons/patron.tscn")
var patrons = []
var patron_groups = {}

var total_patrons_counts : int = 0
var max_patron_counts : int = 0


func _init() -> void:
	Global.patron_manager = self


func _ready() -> void:
	Log.log_error(Events.connect("patron_invoked", self, "invoke_patron"), "patron_manager.gd")
	Log.log_error(Events.connect("clear_patrons_requested", self, "_on_clear_patrons_requested"), "patron_manager.gd")	
	Log.log_error(Events.connect("patron_leaving", self, "_on_patron_leaving"), "patron_manager.gd")
	_load()
	Global.set_patrons_count(patrons.size())


func save() -> Dictionary:
	return {"patrons" : {}}


func _load() -> void:
	if not SaveFile.game_data.has("patrons"):
		_register_children()
		return
#	_delete_all_children()
	var patrons_data = SaveFile.game_data["patrons"]
	for patron in patrons_data:
		print(patron)


func _register_children() -> void:
	for child in get_children():
		if child is Patron:
			patrons.push_back(child)


func _delete_all_children() -> void:
	for child in get_children():
		child.queue_free()


var group_key : int = -1

func _get_next_key() -> int:
	group_key = wrapi(group_key + 1, 0, 9999)
	return group_key


func invoke_patron(invoked_count : int, select : bool) -> void:
	var group_id = _get_next_key()
	var patron = null
	var spawn_pos = Global.entrance_manager.get_entrance()
	if spawn_pos == Vector2.INF:
		# no entrance found
		return
	if invoked_count > 1 :
		var group = []
		var spawn_positions = _generate_spawn_pos(spawn_pos, invoked_count)
		for i in range(invoked_count):
			patron = _spawn_patron(spawn_positions[i], group_id, i == 0, invoked_count)
			patron.is_in_patron_group = true
			patron.sit_index = i
			group.append(patron)
		patron_groups[group_id] = group
	else:
		patron = _spawn_patron(spawn_pos, group_id, false, 0)
	if select:
		Events.emit_signal("entity_selected", patron)
	total_patrons_counts += invoked_count
	var patron_count = patrons.size()
	if patron_count > max_patron_counts:
		max_patron_counts = patron_count
	Global.set_patrons_count(patron_count)


func get_patron_group(patron : Patron) -> Array:
	return patron_groups[patron.group_id]


func is_group_ready_to_leave(patron : Patron) -> bool:
	if not patron.is_in_patron_group:
		return true
	for p in get_patron_group(patron):
		if is_instance_valid(p):
			if not p.ready_to_leave:
				return false
	return true


func _generate_spawn_pos(origin : Vector2, count : int) -> PoolVector2Array:
	# todo, write better offset
	var pos : PoolVector2Array = []
	var offset = Vector2(8,2)
	for _i in range(count):
		pos.push_back(origin)
		origin += offset
	return pos


# do not call direcly, always use patron invoked
func _spawn_patron(
	spawn_pos : Vector2,
	group_id : int, 
	is_group_leader : bool, 
	group_size : int) -> Patron:
	var patron = patron_scene.instance()
	patron.global_position = spawn_pos
	patron.group_id = group_id
	patron.is_group_leader = is_group_leader
	patron.group_size = group_size
	patrons.push_back(patron)
	add_child(patron)
	return patron


func _on_patron_leaving(patron : Patron) -> void:
	if patrons.has(patron):
		patrons.erase(patron)
	if patron.is_group_leader:
		patron_groups.erase(patron.group_id)
	patron.queue_free()
	Global.set_patrons_count(patrons.size())


func _on_clear_patrons_requested() -> void:
	# todo, call cleanup method on patrons
	patrons.clear()
	patron_groups.clear()
	_delete_all_children()
	Global.set_patrons_count(0)
	total_patrons_counts = 0
	max_patron_counts = 0


func all_patrons_leave() -> void:
	for patron in patrons:
		patron.leave()
