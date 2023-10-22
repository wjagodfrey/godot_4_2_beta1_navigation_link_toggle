@tool
extends CharacterBody3D
class_name NPC

const EPSILON = 0.1

@export var walk: bool:
	set(x):
		walk = x
		if not walk:
			global_position = target_1.global_position
			global_rotation = Vector3.ZERO

@export_group("Controls")
@warning_ignore("UNUSED_PRIVATE_CLASS_VARIABLE")
@export var _set_target_1: bool:
	set(_x):
		nav_agent.target_position = target_1.global_position
@warning_ignore("UNUSED_PRIVATE_CLASS_VARIABLE")
@export var _set_target_2: bool:
	set(_x):
		nav_agent.target_position = target_2.global_position

@export_group("Protected")
@export var target_1: Marker3D
@export var target_2: Marker3D
@export var nav_agent: NavigationAgent3D
@export var speed: float = 1


func _ready():
	if Engine.is_editor_hint():
		return
	walk = true


func _physics_process(_delta):
	if not walk:
		return

	update_target()

	if (
		!nav_agent.is_target_reachable()
		and abs(nav_agent.get_final_position().x - global_position.x) < EPSILON
	):
		return

	var target_pos_global = nav_agent.get_next_path_position()
	var target_pos = target_pos_global - global_position
	target_pos.y = 0

	var forward = -global_transform.basis.z
	var angle_to = forward.signed_angle_to(target_pos, Vector3.UP)
	rotation.y += angle_to
	rotation.y = wrapf(rotation.y, -PI, PI)

	velocity = forward * speed
	move_and_slide()


func update_target():
	if abs(global_position.x - target_1.global_position.x) < EPSILON:
		nav_agent.target_position = target_2.global_position
	elif abs(global_position.x - target_2.global_position.x) < EPSILON:
		nav_agent.target_position = target_1.global_position
