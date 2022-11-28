extends ToolboxPanel

onready var stall_name : LineEdit = $CenterContainer/Container/LineEdit_StallName
onready var drop_down : OptionButton = $CenterContainer/Container/OptionButton

var _selected_stall : Stall

func _ready() -> void:
	_add_items()
	drop_down.align = Button.ALIGN_CENTER
	var dish_name = drop_down.get_item_text(0)
	var generated_name = NameDispatcher.get_random_name(dish_name)
	stall_name.text = generated_name


func _add_items() -> void:
	for stall in Resources.STALLS:
		drop_down.add_item(stall)


func load_entity(entity : Entity) -> bool:
	if entity is Stall:
		_update_generated_name()
		_selected_stall = entity as Stall
		return entity.is_stall_vacant
	return false


func unload_entity() -> void:
	_selected_stall = null


func _update_generated_name() -> void:
	var dish_name = drop_down.get_item_text(drop_down.get_selected_id())
	var generated_name = NameDispatcher.get_random_name(dish_name)
	if generated_name == "":
		return
	stall_name.text = generated_name


func _on_ButtonAccept_pressed() -> void:
	var stall_key = drop_down.get_item_text(drop_down.selected)
	if _selected_stall is Stall:
		_selected_stall.create_stall(stall_name.text, Resources.STALLS[stall_key], Global.current_datetime, true)


func _on_OptionButton_item_selected(index: int) -> void:
	var dish_name = drop_down.get_item_text(index)
	var generated_name = NameDispatcher.get_random_name(dish_name)
	if generated_name == "":
		return
	stall_name.text = generated_name
