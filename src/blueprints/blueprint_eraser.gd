extends BlueprintBase
class_name BlueprintEraser

onready var _outline := $StallShape_Outline

func _ready() -> void:
	_outline.visible = false


func set_selected(selected : bool) -> void:
	_outline.visible = selected	


func set_valid(valid : bool) -> void:
	visible = valid
