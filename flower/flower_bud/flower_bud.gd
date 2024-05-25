extends Area2D

enum _growth_stages {
	UNGROWN,
	GROWN,
	GRABBED,
}

var _original_position

var _flower_state:
	set(state):
		if state == _growth_stages.UNGROWN:
			$GrowthTimer.start()
			$Daisy.hide()
		if state == _growth_stages.GROWN:
			$Daisy.show()
			global_position = _original_position
		if state == _growth_stages.GRABBED:
			$Daisy.show()
		_flower_state = state


func _ready():
	_flower_state = _growth_stages.UNGROWN
	_original_position = global_position


func _physics_process(_delta):
	if _flower_state == _growth_stages.GRABBED:
		global_position = get_global_mouse_position()


func _on_growth_timer_timeout():
	_flower_state = _growth_stages.GROWN


func _on_input_event(_viewport, event, _shape_idx):
	if _flower_state == _growth_stages.GROWN and event.is_action_pressed("grab"):
		_flower_state = _growth_stages.GRABBED
	if _flower_state == _growth_stages.GRABBED and event.is_action_released("grab"):
		_flower_state = _growth_stages.GROWN
