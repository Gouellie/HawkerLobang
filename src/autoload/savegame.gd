extends Node
# https://www.youtube.com/watch?v=mV86a8TWSc4&ab_channel=rayuserp

const SAVE_FILE = "user://save_file.save"
const SAVE_FILE2 = "user://save_file_res.tres"
const DATE_KEY = "Date"
const STALLS_KEY = "Stalls"

var current_date : DateTime

var game_data : Dictionary = {}

func _ready() -> void:
	load_data()


func save_game() -> void:
	Events.emit_signal("save_game")
	_save_data()

	
func _save_data() -> void:
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	file.store_var(game_data)
	file.close()


func load_data() -> void:
	var file = File.new()
	if not file.file_exists(SAVE_FILE):
		create_new()
	file.open(SAVE_FILE, File.READ)
	game_data = file.get_var()
	file.close()


func create_new() -> void:
	game_data = {
		DATE_KEY : Dates.to_dictionary(Dates.generate_date(1, 8, 0)),
		STALLS_KEY : {}
	}
	_save_data()


#func load_data2() -> void:
#	var file = File.new()
#	if not file.file_exists(SAVE_FILE2):
#		create_new2()
#	data = ResourceLoader.load(SAVE_FILE2)
#
#
#func create_new2() -> void:
#	data = savegame_resource
#	save_data2()
#
#
#func save_data2() -> void:
#	var err = ResourceSaver.save(SAVE_FILE2, data)
#	if err != OK:
#		print("Failure!")

