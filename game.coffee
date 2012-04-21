class Game
    constructor: () ->
        @frame = 0
        @graphics = new Graphics()
        @timeAtLastFrame = new Date().getTime()
        @leftover = 0.0
        @step = 1000 #ms

    loop: () ->
        t = this
        step = -> t.gameStep()
        setInterval(step, @step / 10)

    start: () ->
        @graphics.setup()
        @graphics.loadScene()
        @graphics.start()
        @started = true
        @loop()

    gameStep: () ->
        timeAtThisFrame = new Date().getTime()
        timeSinceLastDoLogic = (timeAtThisFrame - @timeAtLastFrame) + @leftover;
        catchUpFrameCount = Math.floor(timeSinceLastDoLogic / @step);
        i = 0
        while i < catchUpFrameCount
            @updateLogic()
            @frame += 1
            i++

        @leftover = timeSinceLastDoLogic - (catchUpFrameCount * @step);
        @timeAtLastFrame = timeAtThisFrame;

    updateLogic: () ->
        #game logic here!
