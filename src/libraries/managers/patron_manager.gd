extends Node2D

const patron_scene := preload("res://src/entities/patrons/patron.tscn")

var patrons = []

func _ready() -> void:
	Log.log_error(Events.connect("patron_invoked", self, "_on_patron_invoked"), "patron_manager.gd")
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


func _on_patron_invoked() -> void:
	var patron = patron_scene.instance()
	patron.global_position = Vector2(16,16)
	patrons.push_back(patron)
	add_child(patron)
	Global.set_patrons_count(patrons.size())		


func _on_patron_leaving(patron : Patron) -> void:
	if patrons.has(patron):
		patrons.erase(patron)
	patron.queue_free()
	Global.set_patrons_count(patrons.size())	


func _on_clear_patrons_requested() -> void:
	patrons.clear()
	_delete_all_children()
	Global.set_patrons_count(0)
