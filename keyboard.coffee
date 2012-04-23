class Keyboard
    constructor: (game,graphics) ->
        @graphics = graphics
        @game = game
        @center = new THREE.Vector3(0,0,0)
        @angle = Math.TAU / World.CIRCUMFERENCE
        @target
        @speed = 0
        @dir

        key 'p','game', => @game.pause = !@game.pause
        key 'r','game', => @game.restart()

        key 'up','menu', => @game.onUp?()
        key 'down','menu', => @game.onDown?()
        key 'left','menu', => @game.onLeft?()
        key 'right','menu', => @game.onRight?()
        key 'space','menu', => @game.onSpace?()
        key 'c','menu', => @game.world.reset()

        key 'w', => @graphics.camera.moveUp()
        key 'a', => @graphics.camera.moveLeft()
        key 's', => @graphics.camera.moveDown()
        key 'd', => @graphics.camera.moveRight()

     gameContext: -> key.setScope('game')
     menuContext: -> key.setScope('menu')
