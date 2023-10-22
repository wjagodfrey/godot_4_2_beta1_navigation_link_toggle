@tool
extends MeshInstance3D

@export var enabled: bool:
	set(x):
		enabled = x
		apply_state()

@export_group("Colors")
@export var enabled_color: Color
@export var disabled_color: Color

@export_group("Collision Masks")
@export_flags_3d_physics var enabled_mask: int
@export_flags_3d_physics var disabled_mask: int

@export_group("Protected")
@export var navigation_link: NavigationLink3D
@export var static_body: StaticBody3D
@export var button: Button


func _ready():
	if Engine.is_editor_hint():
		return
	button.pressed.connect(toggle_state)


func toggle_state():
	enabled = !enabled


func apply_state():
	if enabled:
		button.text = "Disable Barrier"
		navigation_link.enabled = false
		static_body.collision_layer = enabled_mask
		mesh.material.albedo_color = enabled_color
	else:
		button.text = "Enable Barrier"
		navigation_link.enabled = true
		static_body.collision_layer = disabled_mask
		mesh.material.albedo_color = disabled_color

