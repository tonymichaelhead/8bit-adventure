extends Area2D

enum STATES { IDLE, ATTACK }

var state = null

var knockback_vector = Vector2.ZERO 

func _ready():
	$AnimationPlayer.play("Idle")
	$'..'.connect('direction_changed', self, "_on_Parent_direction_changed")
	$AnimationPlayer.connect('animation_finished', self, "_on_AnimationPlayer_animation_finished")

#func _physics_process(dt):
#	match state:
#		STATES.IDLE:
#			$AnimationPlayer.play("Idle")
#		STATES.ATTACK:
#			if can_attack:
#				attack()

func attack(direction):
#	if can_attack:
	print('Attack with sword!')
	$'..'.rotate_weapon(direction)
	if direction == "right":
		$AnimationPlayer.play("AttackRight")
	else:	
		$AnimationPlayer.play("AttackSide")

func _on_AnimationPlayer_animation_finished(name):
	if name == 'AttackSide':
		print('Attack animation finished handler')
		$AnimationPlayer.play("Idle")
