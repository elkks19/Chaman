extends Control
@onready var container = $VBoxContainer
@onready var escogerAudio = $VBoxContainer/Escoger
@onready var hoverAudio = $VBoxContainer/Hover

@onready var startButton = $VBoxContainer/StartButton
@onready var quitButton = $VBoxContainer/QuitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	startButton.grab_focus()

func _on_start_button_pressed():
	escogerAudio.play()
	var fade_out_options = SceneManager.create_options(1.0, "scribbles", 0.2, true)
	var fade_in_options = SceneManager.create_options(1.0, "crooked_tiles", 0.2, true)
	var general_options = SceneManager.create_general_options(Color(0, 0, 0), 0, false, true)
	SceneManager.change_scene("level1", fade_out_options, fade_in_options, general_options)


func _on_quit_button_pressed():
	self.set_process_input(false)
	escogerAudio.play()

func _on_start_button_mouse_entered() -> void:
	hoverAudio.play()
	
func _on_quit_button_mouse_entered() -> void:
	hoverAudio.play()
