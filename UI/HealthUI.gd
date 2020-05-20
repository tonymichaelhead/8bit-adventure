extends Control

var hearts: int = 4 setget set_hearts
var max_hearts: int = 4 setget set_max_hearts

onready var heartUIFull := $HeartUIFull
onready var heartUIEmpty := $HeartUIEmpty

func set_hearts(value: int) -> void:
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 32

func set_max_hearts(value: int) -> void:
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 32

func _ready() -> void:
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
