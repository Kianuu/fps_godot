extends Node3D

var body_to_move : CharacterBody3D = null # similar to rust the colon determines the typing

@export var move_accel = 4 
@export var max_speed = 25
var drag = 0.0 
@export var jump_force = 30
@export var gravity = 60



var pressed_jump = false
var move_vec : Vector3
var velocity : Vector3
var snap_vec : Vector3 
@export var ignore_rotation = false # rotation allows for forwards to be always 
# in one direction, so forward will always be in the same way, for the player we dont want this. 

signal movement_info

var frozen = false 

func _ready(): 
	drag = float(move_accel) / max_speed
	
func init(_body_to_move: CharacterBody3D):
	body_to_move = _body_to_move
func jump():
	pressed_jump = true
	
func set_move_vec(_move_vec: Vector3):
	move_vec = _move_vec.normalized()
	
	
@warning_ignore("unused_parameter")
func _physics_process(delta): # runs independent of computer frame, so good for phyiscs
	if frozen:
		return
	var cur_move_vec = move_vec
	
	if !ignore_rotation:
		cur_move_vec = cur_move_vec.rotated(Vector3.UP, body_to_move.rotation.y)
	velocity += move_accel * cur_move_vec - velocity * Vector3(drag, 0, drag) + gravity * Vector3.DOWN * delta
	velocity = body_to_move.get_floor_normal()
	var grounded = body_to_move.is_on_floor()
	if grounded:
		velocity.y = -0.01 # prevents is_on_floor from going false 
	if grounded and pressed_jump:
		velocity.y = jump_force
		snap_vec = Vector3.ZERO
		
	else:
		snap_vec = Vector3.DOWN
	pressed_jump = false
	emit_signal("movement_info", velocity, grounded)
	
func freeze():
	frozen = true
	
func unfreeze():
	frozen = false
	
	
# put input in _process, because input is handled in process frames, not physics frames. So if computer lags, you wont repeat an input extra
