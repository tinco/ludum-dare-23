class Game
    constructor: () ->
        @frame = 0
        @graphics = new Graphics(@)
        @keyboard = new Keyboard(@,@graphics)
        @timeAtLastFrame = new Date().getTime()
        @leftover = 0.0
        @fps = 30
        @step = 1000 # ms
        @pause = false

    loop: () ->
        step = => @gameStep()
        setInterval(step, @step / 10)

    start: () ->
        @graphics.setup()
        @graphics.loadScene()
        @world = new World()
        @graphics.scene.add(@world.mesh)
        @graphics.start()
        @keyboard.start()
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
        if !@pause
            @world.step()
