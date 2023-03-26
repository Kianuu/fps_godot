extends CharacterBody3D

@export var mouse_sens = 0.5

@onready var camera = $Camera3D
@onready var character_move = $CharacterMover


func _ready():
	Input.set_mouse_mode(2)
	character_move.init(self)
	

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec += Vector3.FORWARD
	if Input.is_action_pressed("move_backwards"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
	character_move.set_move_vec(move_vec)
	if Input.is_action_just_pressed("jump"):
		character_move.jump()
		
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
