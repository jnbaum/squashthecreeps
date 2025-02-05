extends Node

@export var mob_scene: PackedScene

@export var mob2_scene: PackedScene


var health = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Retry.hide()
	$UserInterface/Label.hide()
	$UserInterface/Heart1.show()
	$UserInterface/Heart2.show()
	$UserInterface/Heart3.show()
	$UserInterface/Heart4.hide()
	$UserInterface/Heart5.hide()
	$Player.health_changed.connect(_on_reduce_health.bind())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

	# We connect the mob to the score label to update the score upon squashing one.
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

func _on_mob2_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob2 = mob2_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob2_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob2_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob2.initialize(mob2_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob2)

	# We connect the mob to the score label to update the score upon squashing one.
	mob2.squashed.connect($UserInterface/ScoreLabel._on_mob2_squashed.bind())
#func _on_player_hit() -> void:
#		$MobTimer.stop()
#		$UserInterface/Retry.show()
#		$UserInterface/Label.show()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()

func _on_reduce_health(new_health:int):
	health = new_health
	
	if health == 4:
		$UserInterface/Heart5.hide()
	if health == 3:
		$UserInterface/Heart4.hide() 
		$UserInterface/Heart5.hide()
	if health == 2:
		$UserInterface/Heart3.hide()
		$UserInterface/Heart4.hide() 
		$UserInterface/Heart5.hide()
	if health == 1:
		$UserInterface/Heart2.hide()
		$UserInterface/Heart3.hide()
		$UserInterface/Heart4.hide() 
		$UserInterface/Heart5.hide()
	if health <= 0:
		$UserInterface/Heart1.hide()
		$UserInterface/Heart2.hide()
		$UserInterface/Heart3.hide()
		$UserInterface/Heart4.hide() 
		$UserInterface/Heart5.hide()
		$MobTimer.stop()
		$Mob2Timer.stop()
		$UserInterface/Retry.show()
		$UserInterface/Label.show()
