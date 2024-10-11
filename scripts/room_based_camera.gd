extends Camera2D

@export var player: Node2D
@export var room_size: Vector2 
@export var room_based_camera: bool = true
@export var follow_speed: float = 10.0 

var current_room: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO

func _ready():
	if player:
		current_room = (player.global_position / room_size).floor()
		position = current_room * room_size + (room_size / 2)
		target_position = position
		set_physics_process(true) 
	else:
		push_error("Player node not set in RoomCamera!")

func _physics_process(delta):
	if player:
		update_target_position()
		move_camera(delta)
	
	global_position = global_position.round()

func update_target_position():
	if room_based_camera:
		var player_room = (player.global_position / room_size).floor()
		if player_room != current_room:
			current_room = player_room
			target_position = current_room * room_size + (room_size / 2)
	else:
		target_position = player.global_position

func move_camera(delta):
	global_position = global_position.lerp(target_position, follow_speed * delta)

func update_camera_position(new_position: Vector2):
	target_position = new_position
	current_room = (new_position / room_size).floor()

func toggle_room_based_camera():
	room_based_camera = !room_based_camera
	update_target_position()