class Camera extends THREE.PerspectiveCamera
    @MOVE_DURATION = 2
    @DISTANCE = 250

    constructor: (game, rest...) ->
        super rest...
        @game = game
        @column = 0 #(World.CIRCUMFERENCE - 1) / 2
        @row = (World.HEIGHT - 1) / 2
        @position = @game.graphics.calculatePosition(@row, @column, Camera.DISTANCE)
        @lookAt(World.CENTER)

    moveLeft: () -> @moveTo @row, @column - 1
    moveRight: () -> @moveTo @row, @column + 1
    moveUp: () -> @moveTo @row - 1, @column
    moveDown: () -> @moveTo @row + 1, @column

    moveTo: (r,c) ->
        r = if r >= 0 and r < World.HEIGHT then r else @row
        if c == World.CIRCUMFERENCE
            c = 0
        else if c == -1
            c = World.CIRCUMFERENCE - 1
        @row = r
        @column = c

        newPosition = @game.graphics.calculatePosition(r,c, Camera.DISTANCE)
        @currentTween?.stop()
        @currentTween = new TWEEN.Tween(@position).to(newPosition,150)
            .onUpdate(=>@lookAt(World.CENTER))
            .easing( TWEEN.Easing.Linear.None)
            .start()

    calculatePosition: (r,c) ->
        newPosition = @game.world.world[r][c].mesh.position.clone()
        newPosition.normalize().multiplyScalar(Camera.DISTANCE)
        newPosition

    rotX: (position,angle) ->
        newPosition = new THREE.Vector3()
        newPosition.y = position.y*Math.cos(angle) - position.z*Math.sin(angle)
        newPosition.z = position.y*Math.sin(angle) + position.z*Math.cos(angle)
        newPosition.x = position.x
        newPosition

    rotY: (position,angle) ->
        newPosition = new THREE.Vector3()
        newPosition.x = position.x*Math.cos(angle) + position.z*Math.sin(angle)
        newPosition.z = position.z*Math.cos(angle) - position.x*Math.sin(angle)
        newPosition.y = position.y
        newPosition

