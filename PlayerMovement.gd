extends KinematicBody2D

export var playerAcc = 10.0
export var playerMaxSpeed = 500.0
export var rollSpeed = 2000.0
export var maxRollTime = 0.15
export var rollDelay = 0.5
export var canRoll = true

export var friction = 20.0

var rollDirection = Vector2(0.0, 0.0)
var vel = Vector2(0.0, 0.0)
var rolling = false
var timeRolling = 0.0
var timePassedSinceLastRoll = 0.0

func _physics_process(delta):
	var horInput = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var verInput = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	var rollInput = Input.is_action_just_pressed("roll")
	var attackInput = Input.get_action_strength("attack")
	
	if(rollInput and canRoll() and not(horInput == 0.0 and verInput == 0.0)):
		startRolling(horInput, verInput, delta)
		
	if(not rolling):
		timePassedSinceLastRoll += delta
		movePlayer(horInput, verInput, delta)
	else:
		rollMovePlayer(delta)
	
func movePlayer(horInput, verInput, delta):
	var xDir = 0
	var yDir = 0	
	if(horInput < 0):
		xDir = -1 
	else:
		xDir = 1
		
	if(verInput < 0):
		yDir = -1 
	else:
		yDir = 1
		
		
	var xFriction = 0.0
	var yFriction = 0.0
	
	if(vel.y > 0):
		yFriction = -friction
	else:
		yFriction = friction
		
	if(vel.x > 0):
		xFriction = -friction
	else:
		xFriction = friction
		
	var directionVec = Vector2(horInput, verInput).normalized()
	var newXVel = 0.0
	var newYVel = 0.0
	
	if(horInput != 0):
		newXVel = lerp(vel.x, playerMaxSpeed * xDir, delta * playerAcc * directionVec.x * xDir)
	elif(vel.x != 0):
		newXVel = lerp(vel.x, 0, friction * delta)
		
	if(verInput != 0):
		newYVel = lerp(vel.y, playerMaxSpeed * yDir, delta * playerAcc * directionVec.y * yDir)
	elif(vel.y != 0):
		newYVel = lerp(vel.y, 0, friction * delta)
	
	vel = move_and_slide(Vector2(newXVel, newYVel))
	
func rollMovePlayer(delta):
	timeRolling += delta
	if(timeRolling < maxRollTime):
		vel = move_and_slide(rollSpeed * rollDirection)
	else:
		endRolling()	
	
func startRolling(horInput, verInput, delta):
	print("starting rolling " + str(horInput) + " " + str(verInput))
	rollDirection = Vector2(horInput, verInput).normalized()
	rolling = true
	timeRolling = 0.0
	
func endRolling():
	rollDirection = Vector2(0.0, 0.0)
	rolling = false
	timePassedSinceLastRoll = 0.0
	
func canRoll():
	return timePassedSinceLastRoll > rollDelay and !rolling and canRoll
		
	
	
