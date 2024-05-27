extends Area2D
class_name FlowerBud

enum _growth_stages {
	GROWN,
	GRABBED,
	DEAD
}

var _original_position

var _flower_state:
	set(state):
		if state == _growth_stages.GROWN:
			set_collision_layer_value(5, false)
			set_collision_layer_value(6, true)
			position = _original_position
		if state == _growth_stages.GRABBED:
			set_collision_layer_value(5, true)
			set_collision_layer_value(6, false)
		if state == _growth_stages.DEAD:
			$Daisy.hide()
			$Rustle.play()
			$WhitePetals.emitting = true
		_flower_state = state


func _ready() -> void:
	_flower_state = _growth_stages.GROWN


func _physics_process(_delta) -> void:
	if _flower_state == _growth_stages.GRABBED:
		global_position = get_global_mouse_position()


func _on_input_event(_viewport, event, _shape_idx) -> void:
	if _flower_state == _growth_stages.GROWN and event.is_action_pressed("grab"):
		_flower_state = _growth_stages.GRABBED
		z_index = 10
	if _flower_state == _growth_stages.GRABBED and event.is_action_released("grab"):
		_flower_state = _growth_stages.DEAD
		z_index = 2


func _set_original_position(pos):
	_original_position = pos


func _on_white_petals_finished():
	queue_free()
