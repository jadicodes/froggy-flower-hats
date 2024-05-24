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
var _pampered_frog : Frog

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
	if body is Frog and stump_state == StumpState.EMPTY:
		_pampered_frog = body
		stump_state = StumpState.FULL
		emit_signal("ready_to_pamper", body)
		set_texture()


func _on_body_exited(body):
	if body == _pampered_frog:
		stump_state = StumpState.EMPTY
		done_pampering.emit()
		set_texture()


func _get_marker_position():
	return $Marker.global_position
