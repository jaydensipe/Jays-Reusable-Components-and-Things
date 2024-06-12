extends Node3D

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var knockback_component_3d: KnockbackComponent3D = $KnockbackComponent3D

func _on_projectile_component_3d_projectile_collided(collision: KinematicCollision3D) -> void:
		knockback_component_3d.trigger_knockback()
		ResonateIt.play_audio_at_position_3d(audio_stream_player_3d, collision.get_position())
		queue_free()
