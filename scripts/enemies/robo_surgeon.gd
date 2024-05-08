extends PathfindingEnemy

@export var death_overlay_scene: PackedScene

enum BossState {
	IDLE,
	SEARCHING,
	SWIPE,
	SHOOT
}

const STATE_NAME = {
	BossState.IDLE: "IDLE",
	BossState.SEARCHING: "SEARCHING",
	BossState.SWIPE: "SWIPE",
	BossState.SHOOT: "SHOOT"
}

const IDLE_ANIMS = ["BAKED_IdleBackArm", "BAKED_IdleRightArm", "BAKED_IdleLeftArm"]
const IDLE_TIME = 2.0

const SEARCH_MOVE_SPEED = 2.75
const SEARCH_FUDGE_SIZE = 15.0

const SHOOTING_MOVE_SPEED = 2.0
const SHOOT_DISTANCE = 8.0
const SYRINGE_SPEED = 20
const SYRINGE_DAMAGE_MIN = 10
const SYRINGE_DAMAGE_MAX = 15
const SHOT_SPREAD = 0.04
const FIRE_RATE = 5.00
const SYRINGE_LIFETIME = 4
const MAGAZINE_SIZE = 30
const RELOAD_TIME = 3.0

const SWIPE_MOVE_SPEED = 3.5
const SWIPE_ANIM = "BAKED_SawSwing"
const SWIPE_DAMAGE = 40.0

var _last_fire: float = 0
var _remaining_mag: int = MAGAZINE_SIZE:
	set(size):
		_remaining_mag = size
		if size == 0:
			var reload_timer = Timer.new()
			add_child(reload_timer)
			reload_timer.wait_time = RELOAD_TIME
			reload_timer.one_shot = true
			reload_timer.timeout.connect(func(): _remaining_mag = MAGAZINE_SIZE)
			reload_timer.start()
			
var _disabled = false

@onready var _player_ref: CharacterBody3D = get_tree().get_first_node_in_group("Player")
# TODO replace with actual syringe scene
@onready var syringe_scene = preload("res://scenes/projectiles/bullet.tscn")
@onready var muzzle = $RoboSurgeon/Armature/Skeleton3D/Gun_2/Muzzle
@onready var _animation_player: AnimationPlayer = $RoboSurgeon/AnimationPlayer
@onready var _search_timer: Timer = $SearchTimer
@onready var _state: BossState:
	set(state):
		Log.Info("Changing state to %s" % STATE_NAME[state])
		_state = state
		match state:
			BossState.IDLE:
				_idle()
			BossState.SEARCHING:
				_search()
			BossState.SWIPE:
				_swipe()
			BossState.SHOOT:
				_shoot()
				

func _ready():
	# manually connect signals for nodes inside the packed scene
	var saw_area: Area3D = $RoboSurgeon/Armature/Skeleton3D/Saw/SawArea
	saw_area.body_entered.connect(_on_player_enter_saw)
	_animation_player.animation_finished.connect(_anim_finished_handler)
	
	max_health = 500
	cur_health = max_health
	_state = BossState.IDLE
	
func _process(delta):
	if _disabled: return
	match _state:
		BossState.SEARCHING:
			if _navigator.is_target_reached():
				_search()
		BossState.SWIPE:
			# (reacquire player
			set_navigation_target(_get_player_pos())
		BossState.SHOOT:
			# (re)acquire player
			set_navigation_target(_get_player_pos())
			
			# continue shooting at player
			if _last_fire > 1/FIRE_RATE and _remaining_mag > 0:
				_spawn_syringe()
				_last_fire = 0
				_remaining_mag -= 1
			else:
				_last_fire += delta
			pass
		BossState.IDLE:
			# do nothing
			pass
			
func _physics_process(delta: float):
	if _disabled: return
	navigate_to_target(delta)

func _idle():
	set_navigation_target(global_position)
	_animation_player.play(IDLE_ANIMS[randi() % len(IDLE_ANIMS)])

func _search():
	var search_target;
	if randf() < 0.67:
		search_target = _player_ref.global_position
	else:
		var random_offset = Vector3(randi(), 0, randi()).normalized() * SEARCH_FUDGE_SIZE
		search_target = _player_ref.global_position + random_offset
	movement_speed = SEARCH_MOVE_SPEED
	Debug.debug_cube("search", search_target, self)
	set_navigation_target(search_target)
	_search_timer.start()
		
func _swipe():
	movement_speed = SWIPE_MOVE_SPEED
	
func _shoot():
	movement_speed = SHOOTING_MOVE_SPEED
	
func _anim_finished_handler(anim_name: String):
	Log.Info("Finished animation %s" % anim_name)
	if anim_name == SWIPE_ANIM:
		_state = BossState.IDLE
	elif IDLE_ANIMS.has(anim_name):
		_state = BossState.SEARCHING
	else:
		pass
	
func _spawn_syringe():
	var syringe: Area3D = syringe_scene.instantiate()
	syringe.initialize(
		SYRINGE_SPEED, 
		randi_range(SYRINGE_DAMAGE_MIN, SYRINGE_DAMAGE_MAX), 
		SYRINGE_LIFETIME
		)
		
	var adjustedPos = _player_ref.global_position
	adjustedPos.y = 0.9
	Debug.debug_cube("target", adjustedPos, self)
	syringe.global_transform = muzzle.global_transform
	
	
	get_tree().root.add_child(syringe)
	syringe.look_at(adjustedPos, Vector3.UP, true)
	
func _get_player_pos():
	return _player_ref.global_transform.origin
	
func _on_player_spotted(body: Node):
	if not body.is_in_group("Player"): return
	Log.Info("Player spotted!")
	# TODO better decision-making idea
	# 	if distance between player and nearest wall behind them
	# 	is below threshold, try and use the saw (?)
	#if randf() <= 0.5:
		#_state = BossState.SWIPE
	#else:
	_state = BossState.SHOOT
		
func _on_player_lost(body: Node):
	if not body.is_in_group("Player"): return
	Log.Info("Player lost!")
	_state = BossState.SEARCHING

func _on_player_close(body):
	if not body.is_in_group("Player"): return
	Log.Info("Player in melee range")
	_animation_player.play(SWIPE_ANIM)

func _on_player_enter_saw(body):
	if not body.is_in_group("Player"): return
	if not _animation_player.current_animation == SWIPE_ANIM: return
	body.take_damage(SWIPE_DAMAGE)

func die():
	Log.Info("Boss is dead")
	_disabled = true
	PlayerState.credits_earned += 100
	GameState.enemies_killed += 1
	GameState.boss_dead = true
	var death_overlay = death_overlay_scene.instantiate()
	death_overlay.set_text("Victory!")
	death_overlay.set_callback(GameState.reset)
	add_sibling(death_overlay)
