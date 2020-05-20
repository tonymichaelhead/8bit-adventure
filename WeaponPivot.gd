extends Position2D

# Refactor the sprite direction BS to use sword.knockback_direction 
# (could also rename to something else)
func rotate_weapon(sprite_direction):
	if sprite_direction == "left" || sprite_direction == "right":
		position.y = 6
	else:
		position.y = 0
	
	if sprite_direction == "up":
		rotation_degrees = 180
	if sprite_direction == "down":
		rotation_degrees = 0
	if sprite_direction == "left":
		rotation_degrees = 90
	if sprite_direction == "right":
		rotation_degrees = 90
