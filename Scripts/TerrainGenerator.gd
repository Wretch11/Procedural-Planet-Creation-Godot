extends Node2D
	
const WIDTH = 700
const  HEIGHT = 668
const AMP = 0.1
const MOUNTAIN_CAP = 3
const VEG_CAP = 4
const LAND_CAP = 5
const LAND_MARGIN = 100
const WATER_CAP = 4
const WATER_MARGIN = 50
	
const EARTH_BIOME_COLORS = {
	"Mountain" : Color("#B3A171"),
	"Vegetation" : Color("#B3A171"),
	"Ground" : Color("#B3A171"),
	"Water" : Color("#2B3F4A")
	}
	
onready var parent = get_parent()
var terrain_noise
	
func _ready():
	print(parent.name)
	connect_hsliders()
	create_terrain_noise()
	generate_terrain_image()
	initialize_hslider_values()
	
func connect_hsliders():
	for slider in $Sliders.get_children():
		slider.connect("value_changed", self, "_on_slider_value_changed", [slider])
	
func initialize_hslider_values():
	for slider in $Sliders.get_children():
		slider.value = terrain_noise.get(slider.name.to_lower())
		$Labels.get_node(slider.name).text = slider.name + ": " + str(slider.value)
	
func create_terrain_noise():
	randomize()
	terrain_noise = OpenSimplexNoise.new()
	terrain_noise.seed = randi()
	terrain_noise.octaves = 8
	terrain_noise.period = 258
	terrain_noise.persistence = 0.5
	terrain_noise.lacunarity = 2
	
func generate_terrain_image():
	var sprite = $Terrain
	var texture = ImageTexture.new()
	var image_1 = Image.new()
	var seamless = terrain_noise.get_seamless_image(700)
	seamless.lock()
	image_1.create(WIDTH, HEIGHT, true, Image.FORMAT_RGBA8)
	image_1.lock() # To enable drawing with setpixel later
	draw_generated_terrain_img(image_1,seamless)
	texture.create_from_image(image_1, texture.FLAG_REPEAT)
	image_1.fix_alpha_edges()
	image_1.unlock()
	#image_1.compress(Image.COMPRESS_ETC2,Image.COMPRESS_SOURCE_SRGB, 7.0)
	seamless.unlock()
	sprite.texture = texture
	if parent.name == "Planet":
		parent.get_node("Terrain").texture = texture
	
func draw_generated_terrain_img(p_image_1, p_noise):
	for x in p_image_1.get_width():
		for y in p_image_1.get_height():
			var n_sample = p_noise.get_pixel(float(x),float(y))
			var idx = get_pixel_index(n_sample.r8)
			p_image_1.set_pixel(x,y,idx)
	
func get_pixel_index(p_sample):
	p_sample = floor(p_sample * AMP)
	#print(p_sample)
	if p_sample < MOUNTAIN_CAP:
		return EARTH_BIOME_COLORS.Mountain
		print(p_sample)
	if p_sample < VEG_CAP:
		print(p_sample)
		return EARTH_BIOME_COLORS.Vegetation
	if p_sample < LAND_CAP:
		return EARTH_BIOME_COLORS.Ground
	return EARTH_BIOME_COLORS.Water
	
func reset_terrain():
	terrain_noise = null
	$Terrain.texture = null
	
func redraw_terrain():
	$Terrain.texture = null
	generate_terrain_image()
	
func toggle_planet_nodes_visibility():
	if "Planet" in parent.name:
		self.visible = !self.visible
		parent.get_node("Terrain").visible = !parent.get_node("Terrain").visible 
	
func _on_Button_pressed():
	reset_terrain()
	create_terrain_noise()
	generate_terrain_image()
	
func _on_RedrawBtn_pressed():
	redraw_terrain()
	
func _on_slider_value_changed(p_value,p_slider):
	var property = p_slider.name.to_lower()
	terrain_noise.set(property,p_value) 
	$Labels.get_node(p_slider.name).text = p_slider.name + ": " + str(p_slider.value)
	
func _on_ApplyTexBtn_pressed():
	parent.get_node("Terrain").texture = $Terrain.texture
	toggle_planet_nodes_visibility()
	
func _on_SavePngBtn_pressed():
	var image = $Terrain.texture.get_data()
	image.flip_y()
	image.clear_mipmaps()
	image.save_png("C:/Users/aaa/Desktop/gen01.png")
	print("image saved")
	
