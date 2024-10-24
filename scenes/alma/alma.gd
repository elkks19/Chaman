extends Area2D

func _ready():
	$AnimatedSprite2D.play("default")


func _on_body_entered(body):
	picked.emit()
	queue_free()

signal picked
