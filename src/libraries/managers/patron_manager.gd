extends Node2D

var patrons = []

func _ready() -> void:
	for child in get_children():
		if child is Patron:
			patrons.push_back(child)
