extends Node2D

const patron_scene := preload("res://src/entities/patrons/patron.tscn")
var patrons = []

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


func invoke_patron(invoked_count : int, select : bool) -> void:
	var patron = null
	var spawn_pos = Global.entrance_manager.get_entrance()
	if invoked_count > 1 :
		var spawn_positions = _generate_spawn_pos(spawn_pos, invoked_count)
		for i in range(invoked_count):
			patron = _spawn_patron(spawn_positions[i])
	else:
		patron = _spawn_patron(spawn_pos)
	if select:
		Events.emit_signal("entity_selected", patron)
	Global.set_patrons_count(patrons.size())


func _generate_spawn_pos(origin : Vector2, count : int) -> PoolVector2Array:
	# todo, write better offset
	var pos : PoolVector2Array = []
	var offset = Vector2(8,2)
	for _i in range(count):
		pos.push_back(origin)
		origin += offset
	return pos


# do not call direcly, always use patron invoked
func _spawn_patron(spawn_pos : Vector2) -> Patron:
	var patron = patron_scene.instance()
	patron.global_position = spawn_pos
	patrons.push_back(patron)
	add_child(patron)
	return patron


func _on_patron_leaving(patron : Patron) -> void:
	if patrons.has(patron):
		patrons.erase(patron)
	patron.queue_free()
	Global.set_patrons_count(patrons.size())	


func _on_clear_patrons_requested() -> void:
	patrons.clear()
	_delete_all_children()
	Global.set_patrons_count(0)
