class Game
    constructor: () ->
        @frame = 0
        @graphics = new Graphics(@)
        @keyboard = new Keyboard(@,@graphics)
        @timeAtLastFrame = new Date().getTime()
        @leftover = 0.0
        @fps = 30
        @step = 1000 # ms
        @pause = true

    loop: () ->
        step = => @gameStep()
        setInterval(step, @step / 10)

    start: () ->
        @world = new World()
        @graphics.start(@world)
        @keyboard.start()
        @populateMenu()
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

    populateMenu: () ->
        for kind, name of Cell.Kinds
            $('#tileMenu').append($('<li>').append(name))
        @selectTile(1) #select Earth by default

    selectTile:(i) ->
        $('#tileMenu > li').eq(@selectedTile)?.removeClass('selected')
        @selectedTile = i
        $('#tileMenu > li').eq(@selectedTile).addClass('selected')

    onUp: () ->
        @selectTile(if @selectedTile == 0 then Cell.KindsAmount - 1 else @selectedTile - 1)

    onDown: () ->
        @selectTile((@selectedTile + 1) % Cell.KindsAmount)

    onSpace: () ->
        @world.changeTile(@graphics.camera.row, @graphics.camera.column, @selectedTile)

    updateLogic: () ->
        if !@pause
            @world.step()
            if @world.finished
                @pause = true
