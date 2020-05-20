extends KinematicBody2D

export var ACCELERATION: int = 300
export var MAX_SPEED: int = 50
export var FRICTION: int = 200

const KNOCKBACK_FORCE: int = 140
const KNOCKBACK_FRICTION: int = 200
const SOFT_COLLISION_FORCE: int = 400

var velocity := Vector2.ZERO
var knockback := Vector2.ZERO

onready var sprite := $AnimatedSprite 
onready var stats := $Stats
onready var playerDetectionZone := $PlayerDetectionZone
onready var hurtbox := $Hurtbox
onready var softCollision := $SoftCollision

enum States { 
	IDLE,
	WANDER,
	CHASE,
}

var state = States.CHASE

func _ready():
	sprite.play("Walking")
	print(stats.max_health)
	print(stats.health)

func _physics_process(dt):
	knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * dt)
	knockback = move_and_slide(knockback)
	
	match state:
		States.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * dt)
			seek_player()
		States.WANDER:
			pass
		States.CHASE:
			var player: Player = playerDetectionZone.player
			if player != null:
				var direction: Vector2 = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * dt)
			else:
				state = States.IDLE
			sprite.flip_h = velocity.x > 0

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * dt * SOFT_COLLISION_FORCE
	velocity = move_and_slide(velocity)

func seek_player() -> void:
	if playerDetectionZone.player_detected():
		state = States.CHASE

func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	knockback = area.knockback_vector * KNOCKBACK_FORCE
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	queue_free()
