extends Node2D

var patrons = []

func _ready() -> void:
	Log.log_error(Events.connect("clear_patrons_requested", self, "_on_clear_patrons_requested"), "patron_manager.gd")
	_load()
	Global.set_patrons_count(get_child_count())


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


func _on_clear_patrons_requested() -> void:
	_delete_all_children()
	Global.set_patrons_count(0)
