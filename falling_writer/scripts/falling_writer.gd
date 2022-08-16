extends Control

const _falling_label_box: PackedScene = preload("res://falling_writer/components/falling_lable_box.tscn")
const _typing_sounds = [
	preload("res://falling_writer/assets/sounds/typing/typing_1.wav"),
	preload("res://falling_writer/assets/sounds/typing/typing_2.wav"),
	preload("res://falling_writer/assets/sounds/typing/typing_3.wav"),
	preload("res://falling_writer/assets/sounds/typing/typing_4.wav"),
	preload("res://falling_writer/assets/sounds/typing/typing_5.wav"),
]

onready var _text_edit: TextEdit = get_node("%TextEdit")
onready var _node_2d: Node2D = get_node("%Node2D")
onready var _audio: AudioStreamPlayer = get_node("%AudioStreamPlayer")
onready var _word_count: Label = get_node("%WordCount/Label")
onready var _char_count: Label = get_node("%CharCount/Label")


func _ready():
	OS.min_window_size = get_tree().get_root().get_node("FallingWriter").rect_min_size
	randomize()


func _on_TextEdit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.unicode > 20 and event.unicode < 126:
			var FallingLabelBox = _falling_label_box.instance()

			FallingLabelBox.get_node("Label").text = char(event.unicode)
			FallingLabelBox.position.x = rand_range(0, OS.window_size.x)
			FallingLabelBox.position.y = -FallingLabelBox.get_node("ColorRect").rect_size.x / 2

			_node_2d.add_child(FallingLabelBox)

		_audio.stream = _typing_sounds[randi() % _typing_sounds.size()]
		_audio.play()

		_update_word_count()
		_update_char_count()


func _update_word_count() -> void:
	var regex := RegEx.new()
	var _err = regex.compile("\\S+")
	var result := regex.search_all(_text_edit.text)
	_word_count.text = str(result.size())
	
	
func _update_char_count() -> void:
	_char_count.text = str(_text_edit.text.length())
