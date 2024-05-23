extends Area2D

signal ready_to_pamper(body)
signal done_pampering

const FULL_TEXTURE = preload("res://stump/full.png")
const EMPTY_TEXTURE = preload("res://stump/empty.png")

enum StumpState {
	FULL,
	EMPTY
	}

var stump_state = StumpState.EMPTY


func _ready():
	set_texture()


func set_texture():
	match stump_state:
		StumpState.FULL:
			_set_sprite_texture(FULL_TEXTURE)
		StumpState.EMPTY:
			_set_sprite_texture(EMPTY_TEXTURE)


func _set_sprite_texture(tex):
	$Sprite.texture = tex


func _on_body_entered(body):
	if stump_state == StumpState.FULL:
		return
	if body is Frog:
		if stump_state == StumpState.EMPTY:
			stump_state = StumpState.FULL
			emit_signal("ready_to_pamper", body)
		set_texture()


func _on_body_exited(body):
	if body is Frog:
		stump_state = StumpState.EMPTY
		done_pampering.emit()
		set_texture()


func _get_marker_position():
	return $Marker.global_position
