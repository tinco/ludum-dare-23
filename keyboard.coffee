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
        key 'f','game', => @game.finish()

        key 'enter','tutorial', => @game.seedMode()

        key 'up','menu', => @game.onUp?()
        key 'down','menu', => @game.onDown?()
        key 'left','menu', => @game.onLeft?()
        key 'right','menu', => @game.onRight?()
        key 'space','menu', => @game.onSpace?()

        key '1','menu', => @game.selectTile(0)
        key '2','menu', => @game.selectTile(1)
        key '3','menu', => @game.selectTile(2)
        key '4','menu', => @game.selectTile(3)
        key '5','menu', => @game.selectTile(4)

        key 'c','menu', => @game.world.reset()

        key 'w', => @graphics.camera.moveUp()
        key 'a', => @graphics.camera.moveLeft()
        key 's', => @graphics.camera.moveDown()
        key 'd', => @graphics.camera.moveRight()

     gameContext: -> key.setScope('game')
     menuContext: -> key.setScope('menu')
     tutorialContext: -> key.setScope('tutorial')
