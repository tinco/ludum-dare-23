class Keyboard
    constructor: (game,graphics) ->
        @graphics = graphics
        @game = game
        @center = new THREE.Vector3(0,0,0)
        @angle = Math.TAU / World.CIRCUMFERENCE
        @target
        @speed = 0
        @dir

    start: () ->
        key 'w', => @graphics.camera.moveUp()
        key 'a', => @graphics.camera.moveLeft()
        key 's', => @graphics.camera.moveDown()
        key 'd', => @graphics.camera.moveRight()
        key 'p', => @game.pause = !@game.pause

        key 'up', => @game.onUp?()
        key 'down', => @game.onDown?()
        key 'left', => @game.onLeft?()
        key 'right', => @game.onRight?()

        key 'space', => @game.onSpace?()
