extends Area2D
class_name PlayerDetectionZone

var player: KinematicBody2D = null

func player_detected() -> bool:
	return player != null

func _on_PlayerDetectionZone_body_entered(body: KinematicBody2D) -> void:
	player = body


func _on_PlayerDetectionZone_body_exited(body:KinematicBody2D) -> void:
	player = null
