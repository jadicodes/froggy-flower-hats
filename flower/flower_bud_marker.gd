extends Marker2D

var _has_flower: bool = false


func _check_has_flower() -> bool:
	if not _has_flower:
		_has_flower = true
		return true
	else:
		return false
