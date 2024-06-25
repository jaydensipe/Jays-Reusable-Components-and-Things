extends CenterContainer
class_name CrosshairComponent

@export_group("Normal")
@export var normal_crosshair: Crosshair
@export_group("Interact")
@export var enable_interact: bool = false
@export var interact_component: InteractionComponent3D
@export var interact_crosshair: Crosshair
@export_group("Config")
@export_range(0.0, 10.0) var tween_time: float = 0.15
var _crosshair_sprite: Sprite2D

func _ready() -> void:
	set_anchors_preset(Control.PRESET_CENTER, true)
	mouse_filter = MOUSE_FILTER_IGNORE

	_crosshair_sprite = Sprite2D.new()
	_crosshair_sprite.texture = normal_crosshair.texture
	_crosshair_sprite.scale = Vector2(normal_crosshair.crosshair_scale, normal_crosshair.crosshair_scale)
	add_child(_crosshair_sprite)

	if (enable_interact):
		_init_interactable()

func _init_interactable() -> void:
	assert(is_instance_valid(interact_component))

	interact_component.hovered_interactable.connect(func(interactable: TriggerInteract) -> void:
		switch_crosshair(interact_crosshair.texture, interact_crosshair.crosshair_scale)
	)

	interact_component.stopped_hovering.connect(func(interactable: TriggerInteract) -> void:
		_reset_to_normal_crosshair()
	)

func _reset_to_normal_crosshair() -> void:
	switch_crosshair(normal_crosshair.texture, normal_crosshair.crosshair_scale)

func switch_crosshair(crosshair_texture: Texture2D, crosshair_scale: float) -> void:
	await create_tween().tween_property(self, "modulate:a", 0.0, tween_time).finished

	create_tween().tween_property(self, "modulate:a", 1.0, tween_time)
	_crosshair_sprite.texture = crosshair_texture
	_crosshair_sprite.scale = Vector2(crosshair_scale, crosshair_scale)
