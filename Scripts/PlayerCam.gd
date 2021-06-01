extends Camera2D

const ZOOM_DEFAULT = Vector2(1,1)
const ZOOM_CHANGE = Vector2(0.1,0.1)
const CAM_SPEED = 200.0


var is_panning
var speed_boost = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	current = true
	SignalEventManager.connect("planet_zoom_in", self, "_on_planet_zoom_in")
	SignalEventManager.connect("planet_selected",self,"_on_planet_selected")
	set_process_unhandled_input(true)


func _process(delta):
	move_camera(delta)
	#zoom_camera()
	is_panning = Input.is_action_pressed("mmb")
	
	
func move_camera(p_delta):
	if Input.is_action_pressed("Cam_Up"):
		self.global_position += (CAM_SPEED * p_delta * Vector2.UP) * zoom * speed_boost
	if Input.is_action_pressed("Cam_Down"):
		self.global_position += (CAM_SPEED * p_delta * Vector2.DOWN) * zoom * speed_boost
	if Input.is_action_pressed("Cam_Left"):
		self.global_position += (CAM_SPEED * p_delta * Vector2.LEFT) * zoom * speed_boost
	if Input.is_action_pressed("Cam_Right"):
		self.global_position += (CAM_SPEED * p_delta * Vector2.RIGHT) * zoom * speed_boost

func _input(event):
	if Input.is_action_pressed("zoom_in"):
		self.zoom -= ZOOM_CHANGE * speed_boost
	if Input.is_action_pressed("zoom_out"):
		self.zoom += ZOOM_CHANGE * speed_boost
	if Input.is_action_just_pressed("Reset_Zoom"):
		self.zoom = ZOOM_DEFAULT 
	if Input.is_action_just_pressed("Boost"):
		speed_boost = 4
	if Input.is_action_just_released("Boost"):
		speed_boost = 1

func _on_planet_selected(p_pos):
	self.global_position = p_pos
	
func _on_planet_zoom_in():
	self.zoom = ZOOM_DEFAULT
