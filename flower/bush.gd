extends Area2D

const _MAX_FLOWERS: int = 3

var _flower_bud : FlowerBud
var _current_flowers = 0
var _possible_times: Array = [3, 5, 7, 8, 9]
@onready var _markers: Array = [$FlowerBudMarker, $FlowerBudMarker2, $FlowerBudMarker3]


func _ready():
	_set_timer()


func _set_timer() -> void:
	$GrowthTimer.wait_time = _possible_times.pick_random()


func _grow_flower() -> void:
	_flower_bud = preload("res://flower/flower_bud/flower_bud.tscn").instantiate()
	call_deferred("add_child", _flower_bud)
	_flower_bud.global_position = _find_position()
	_current_flowers += 1
	_set_timer()


func _on_growth_timer_timeout() -> void:
	if _current_flowers < _MAX_FLOWERS:
		_grow_flower()


func _find_position():
	for _marker in _markers:
		var _can_grow = _marker._check_has_flower()
		if _can_grow:
			return _marker.position
