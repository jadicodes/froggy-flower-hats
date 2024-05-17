extends CharacterBody2D
class_name Frog


const SPEED = 100.0

const WALK = preload("res://frog/walk.png")
const IDLE = preload("res://frog/idle.png")
const GRABBED = preload("res://frog/grabbed.png")
const BEING_PAMPERED = preload("res://frog/being_pampered.png")
const FALLING = preload("res://frog/falling.png")

enum frog_state {
	WALK,
	IDLE,
	GRABBED,
	FALLING,
	BEING_PAMPERED,
}

var _possible_times: Array = [3, 5]
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direction

var _frog_state:
	set(state):
		if state == frog_state.WALK:
			_set_sprite_texture(WALK)
			_set_physics_layer(2)
			_direction = [1, -1].pick_random()

		if state == frog_state.IDLE:
			_set_sprite_texture(IDLE)
			_set_physics_layer(2)

		if state == frog_state.GRABBED:
			_set_sprite_texture(GRABBED)
			_set_physics_layer(1)

		if state == frog_state.FALLING:
			_set_sprite_texture(FALLING)
			_set_physics_layer(2)

		if state == frog_state.BEING_PAMPERED:
			_set_sprite_texture(BEING_PAMPERED)
			_set_physics_layer(2)
			_set_timer()

		_frog_state = state


func _ready():
	_frog_state = frog_state.WALK
	_set_timer()


func _physics_process(delta):
	if _frog_state == frog_state.GRABBED:
		position = get_global_mouse_position()


	if _frog_state == frog_state.FALLING:
		velocity.y += _gravity * delta
		velocity.x = 0
		
		if is_on_floor():
			_frog_state = frog_state.IDLE


	if _frog_state == frog_state.WALK:
		velocity.y += _gravity * delta
		if _direction:
			velocity.x = _direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	if _frog_state == frog_state.IDLE:
		velocity.y += _gravity * delta
		velocity.x = 0

	if _frog_state == frog_state.BEING_PAMPERED:
		velocity.y = 0
		velocity.x = 0

	move_and_slide()


func _set_state(state: int) -> void:
	_frog_state = state


func _set_timer():
	$DecisionTimer.wait_time = _possible_times.pick_random()


func _set_sprite_texture(texture: CompressedTexture2D) -> void:
	$Sprite.texture = texture


func _set_physics_layer(_layer):
	collision_layer = _layer
	collision_mask = _layer


func _on_decision_timer_timeout():
	if _frog_state == frog_state.WALK:
		_frog_state = frog_state.IDLE
		return

	if _frog_state == frog_state.IDLE:
		_frog_state = frog_state.WALK
		return


func _on_grab_detector_input_event(_viewport, event, _shape_idx):
	if _frog_state != frog_state.GRABBED and event.is_action_pressed("grab"):
		_frog_state = frog_state.GRABBED
	if _frog_state == frog_state.GRABBED and event.is_action_released("grab"):
		_frog_state = frog_state.FALLING


func _get_state():
	return _frog_state