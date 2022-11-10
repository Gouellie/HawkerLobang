extends Panel
class_name BlueprintPanel

export (PackedScene) var blueprint_scene

onready var center_position : Control = $CenterContainer/Blueprint_position

var _selected : bool
var _blueprint : Blueprint
var _is_mouse_over : bool

func _ready() -> void:
	Log.log_error(Events.connect("blueprint_selected", self, "_on_blueprint_selected"), "blueprint.gd")
	if blueprint_scene:
		_blueprint = blueprint_scene.instance() as Blueprint
		_blueprint.position = center_position.rect_position
		add_child(_blueprint)


func _input(event: InputEvent) -> void:
	if not _is_mouse_over:
		return
	if event is InputEventMouseButton and event.is_action_pressed("ui_select"):
		if _selected:
			Events.emit_signal("blueprint_selected", null)
		else:
			Events.emit_signal("blueprint_selected", self)


func _on_blueprint_selected(sender : Object) -> void:
	_selected = sender == self
	if _blueprint :
		_blueprint.set_selected(_selected)


func _on_BlueprintPanel_mouse_entered(p_mouse_over: bool) -> void:
	_is_mouse_over = p_mouse_over

