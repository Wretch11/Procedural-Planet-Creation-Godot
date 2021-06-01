extends TextureRect

onready var planet_pos = $Terrain/Position2D.global_position
onready var parent = get_parent()

func _ready():
	if parent != null:
		$Terrain.visible = false
		$TerrainGenerator.visible = true
		
func _process(delta):
	$CanvasLayer/FpsMonitor.text = Engine.get_frames_per_second()

func _on_Planet_gui_input(event):
	if InputEventMouseButton\
	and event.is_pressed() and event.doubleclick:
		SignalEventManager.emit_signal("planet_zoom_in")
	else:
		if Input.is_action_pressed("LMB"):
			if parent.name == "World":
				SignalEventManager.emit_signal("planet_selected", planet_pos)
			else:
				$Terrain.visible = false
				$TerrainGenerator.visible = true
