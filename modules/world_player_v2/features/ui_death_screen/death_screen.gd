extends CanvasLayer
class_name DeathScreen
## DeathScreen - Displays when player dies and auto-restarts after countdown

signal restart_requested

@onready var panel: PanelContainer = $Panel
@onready var title_label: Label = $Panel/VBox/TitleLabel
@onready var message_label: Label = $Panel/VBox/MessageLabel
@onready var countdown_label: Label = $Panel/VBox/CountdownLabel
@onready var vignette: ColorRect = $Vignette

var is_visible: bool = false
var countdown_timer: float = 5.0
var countdown_active: bool = false

func _ready() -> void:
	# Start hidden
	visible = false
	if panel:
		panel.modulate.a = 0.0
	if vignette:
		vignette.modulate.a = 0.0
	
	# Connect to player death signal
	if has_node("/root/PlayerSignals"):
		PlayerSignals.player_died.connect(_on_player_died)
	
	print("[DeathScreen] Initialized")

func _process(delta: float) -> void:
	if countdown_active and is_visible:
		countdown_timer -= delta
		
		# Update countdown display
		var remaining = ceil(countdown_timer)
		if countdown_label:
			countdown_label.text = "Restarting in %d" % remaining
		
		# When countdown reaches 0, restart
		if countdown_timer <= 0:
			countdown_active = false
			_restart_game()

func show_death_screen() -> void:
	if is_visible:
		return
	
	is_visible = true
	visible = false  # Keep hidden until fade in starts
	
	# Reset countdown
	countdown_timer = 5.0
	countdown_active = true
	
	# Fade in vignette
	if vignette:
		vignette.modulate.a = 0.0
		visible = true
		var tween = create_tween()
		tween.tween_property(vignette, "modulate:a", 0.8, 1.0)
	
	# Fade in panel after short delay
	await get_tree().create_timer(0.5).timeout
	
	if panel:
		panel.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(panel, "modulate:a", 1.0, 0.5)
	
	# Start countdown after panel is visible
	if countdown_label:
		countdown_label.text = "Restarting in 5"
	
	print("[DeathScreen] Death screen shown, countdown started")

func hide_death_screen() -> void:
	if not is_visible:
		return
	
	is_visible = false
	countdown_active = false
	
	# Fade out
	if panel:
		var tween = create_tween()
		tween.tween_property(panel, "modulate:a", 0.0, 0.3)
	
	if vignette:
		var tween = create_tween()
		tween.tween_property(vignette, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): visible = false)
	
	print("[DeathScreen] Death screen hidden")

func _on_player_died() -> void:
	print("[DeathScreen] Player died signal received")
	show_death_screen()

func _restart_game() -> void:
	print("[DeathScreen] Auto-restarting game")
	
	# Reset player stats before reload
	if has_node("/root/PlayerStats"):
		PlayerStats.reset()
	
	# Reload the current scene (this will reset everything including player, HUD, etc.)
	get_tree().reload_current_scene()
	
	print("[DeathScreen] Game restarted")