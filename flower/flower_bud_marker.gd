extends Marker2D

var _has_flower: bool = false


func _check_has_flower() -> bool:
	return _has_flower


func _on_area_2d_area_entered(_area):
	_has_flower = true


func _on_area_2d_area_exited(_area):
	_has_flower = false
