class Game
    constructor: () ->
        @graphics = new Graphics()
    loop: () ->
        #update game logic
    start: () ->
        @graphics.setup()
        @graphics.loadScene()
        @graphics.start()
        @started = true
