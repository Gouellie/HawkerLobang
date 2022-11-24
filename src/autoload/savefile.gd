extends Node
# https://www.youtube.com/watch?v=mV86a8TWSc4&ab_channel=rayuserp

const SAVE_FILE_DIR = "user://savefiles"
const SAVE_FILE = "user://savefiles/save_file.save"

var game_data : Dictionary
var current_save_file : String = SAVE_FILE


static func save_file_found() -> bool:
	var dir = Directory.new()
	if dir.open(SAVE_FILE_DIR) != OK:
		return false
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".save"):
			dir.list_dir_end()
			return true
		file_name = dir.get_next()
	dir.list_dir_end()
	return false


func new_game() -> void:
	current_save_file = SAVE_FILE
	game_data = {}


func save_game(save_file : String = "") -> void:
	var dir = Directory.new()
	if dir.open(SAVE_FILE_DIR) != OK:
		dir.make_dir(SAVE_FILE_DIR)
	current_save_file = save_file if save_file != "" else current_save_file
	if not current_save_file.ends_with(".save"):
		current_save_file += ".save"
		
	var save_game = File.new() as File
	save_game.open(current_save_file, File.WRITE)
	game_data = {}
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")
		for key in node_data:
			game_data[key] = node_data[key]

	save_game.store_string(to_json(game_data))
	print("game saved to %s" % current_save_file)
	save_game.close()


func load_game(filepath : String) -> void:
	var save_game = File.new() as File
	if not save_game.file_exists(filepath):
		return # Error! We don't have a save to load.
	current_save_file = filepath
	save_game.open(filepath, File.READ)
	var data = parse_json(save_game.get_as_text())
	# the content of the savefile is cached in game_data
	# interested nodes can retrieve the data 
	game_data = data if data is Dictionary else {}
	save_game.close()


# call when the scene is already loaded
func reload_game(filepath : String) -> void:
	load_game(filepath)	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if !node.has_method("reload"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		node.reload(game_data)

