extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()


func _on_start_button_pressed():
	$VBoxContainer/Escoger.play()
	get_tree().change_scene("")
	


func _on_quit_button_pressed():
	$VBoxContainer/Escoger.play()
	get_tree().quit()
	


func _on_start_button_mouse_entered() -> void:
	$VBoxContainer/Hover.play()


func _on_quit_button_mouse_entered() -> void:
	$VBoxContainer/Hover.play()
