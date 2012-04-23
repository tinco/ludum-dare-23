class Camera extends THREE.PerspectiveCamera
    @MOVE_DURATION = 2
    @DISTANCE = 250

    constructor: (game, rest...) ->
        super rest...
        @game = game
        @graphics = game.graphics
        @column = 0 #(World.CIRCUMFERENCE - 1) / 2
        @row = (World.HEIGHT - 1) / 2
        @position = @graphics.calculatePosition(@row, @column, Camera.DISTANCE)
        @lookAt(World.CENTER)

    updateSelectionPosition: () ->
        @graphics.scene?.remove(@selectionMesh)
        @selectionMesh = new THREE.Mesh(
            new THREE.CubeGeometry(@game.world.world[@row][@column].length,Cell.Size,Cell.Height+1),new THREE.MeshBasicMaterial(color:0xFFFFFF, wireframe:!0))
        @selectionMesh.position = @game.world.world[@row][@column].mesh.position
        @selectionMesh.rotation = @game.world.world[@row][@column].mesh.rotation
        @graphics.scene?.add(@selectionMesh)

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
        @updateSelectionPosition()

        newPosition = @graphics.calculatePosition(r,c, Camera.DISTANCE)
        @currentTween?.stop()
        @currentTween = new TWEEN.Tween(@position).to(newPosition,150)
            .onUpdate(=>@lookAt(World.CENTER))
            .easing( TWEEN.Easing.Linear.None)
            .start()
