extends Node3D

@onready var weapon_component: WeaponComponent = $WeaponComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var decal_spawner_3d: SpawnerComponent3D = $DecalSpawner3D
@onready var audio_gunshot_player: AudioStreamPlayer = $AudioGunshotPlayer
@onready var audio_reload_player: AudioStreamPlayer = $AudioReloadPlayer

var _current_state: REVOLVER_SHOOT_STATE = REVOLVER_SHOOT_STATE.IDLE
enum REVOLVER_SHOOT_STATE {
	IDLE,
	SHOOTING,
	RELOADING,
}

func _ready() -> void:
	weapon_component.primary_pressed.connect(func():
		_shared_between_primary_and_alternate(10.0, weapon_component.get_stats().fire_rate)
		audio_gunshot_player.pitch_scale = 1.0
	)

	weapon_component.alternate_pressed.connect(func():
		_shared_between_primary_and_alternate(20.0, weapon_component.get_stats().fire_rate * 0.75)
		audio_gunshot_player.pitch_scale = 0.9
	)

	weapon_component.reload_pressed.connect(func():
		if (_current_state != REVOLVER_SHOOT_STATE.IDLE): return

		animation_player.play("revolver_reload")
		audio_reload_player.play()
		_current_state = REVOLVER_SHOOT_STATE.RELOADING
	)

func _shared_between_primary_and_alternate(range: float, anim_speed: float):
	if (weapon_component.get_stats().ammo <= 0 or _current_state != REVOLVER_SHOOT_STATE.IDLE): return

	_current_state = REVOLVER_SHOOT_STATE.SHOOTING
	weapon_component.get_stats().ammo -= 1
	animation_player.play("revolver_shoot", -1, anim_speed)
	audio_gunshot_player.play()
	var hit: Dictionary = RaycastIt3D.ray_from_camera_3d(range, true)
	if (hit != {}):
		var decal: Decal = decal_spawner_3d.spawn_at_location(hit["position"])
		decal.look_at(hit["position"] + hit["normal"], Vector3.UP)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "revolver_reload"):
		weapon_component.get_stats().ammo = weapon_component.get_stats().max_ammo

	_current_state = REVOLVER_SHOOT_STATE.IDLE