extends Node2D

var patrons = []

func _ready() -> void:
	_load()


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
