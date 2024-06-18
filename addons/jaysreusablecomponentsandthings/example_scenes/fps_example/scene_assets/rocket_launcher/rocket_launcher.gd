extends FPItem3D

@onready var weapon_component: WeaponComponent = $WeaponComponent
@onready var scene_spawn_component_3d: SceneSpawnComponent3D = $SceneSpawnComponent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _current_state: ROCKET_LAUNCHER_SHOOT_STATE = ROCKET_LAUNCHER_SHOOT_STATE.IDLE
enum ROCKET_LAUNCHER_SHOOT_STATE {
	IDLE,
	SHOOTING,
	RELOADING,
}

func _ready() -> void:
	weapon_component.primary_pressed.connect(func()  -> void:
		if (weapon_component.get_stats().ammo <= 0 or _current_state != ROCKET_LAUNCHER_SHOOT_STATE.IDLE): return

		_current_state = ROCKET_LAUNCHER_SHOOT_STATE.SHOOTING
		weapon_component.get_stats().ammo -= 1
		animation_player.play("rocket_launcher_shoot", -1, weapon_component.get_stats().fire_rate)
		scene_spawn_component_3d.spawn_at_location_with_transform()
	)

	weapon_component.reload_pressed.connect(func()  -> void:
		if (_current_state != ROCKET_LAUNCHER_SHOOT_STATE.IDLE): return

		animation_player.play("rocket_launcher_reload")
		_current_state = ROCKET_LAUNCHER_SHOOT_STATE.RELOADING
	)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "rocket_launcher_reload"):
		weapon_component.get_stats().ammo = weapon_component.get_stats().max_ammo

	_current_state = ROCKET_LAUNCHER_SHOOT_STATE.IDLE
