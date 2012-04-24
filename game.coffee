class Game
    constructor: () ->
        @frame = 0
        @graphics = new Graphics(@)
        @keyboard = new Keyboard(@,@graphics)
        @audio = new Audio()
        @timeAtLastFrame = new Date().getTime()
        @leftover = 0.0
        @fps = 30
        @step = 1000 # ms
        @pause = true
        @placed = 0

    loop: () ->
        step = => @gameStep()
        setInterval(step, @step / 10)

    start: () ->
        @world = new World(@)
        @graphics.start(@world)
        @populateMenu()
        @tutorialMode()
        @loop()

    hideAll: () ->
        $('#tileMenu').hide()
        $('#score').hide()
        $('#finish').hide()
        $('#tutorial').hide()

    tutorialMode: () ->
        @hideAll()
        $('#tutorial').show()
        @keyboard.tutorialContext()

    gameMode: () ->
        @placed = 0
        @savedState = @world.saveState()
        for row in @savedState
            for cell in row
                @placed += 1 if cell

        @hideAll()
        $('#score').show()
        @keyboard.gameContext()
        @pause = false

    seedMode:() ->
        @hideAll()
        $('#tileMenu').show()
        @keyboard.menuContext()

    endMode:() ->
        $('#score').hide()
        $('#tileMenu').hide()

    restart: () ->
        $('#finish').hide()
        @seedMode()
        @world.loadState @savedState
        
    toggleHelp: () ->
        $('#help').toggle()

    gameStep: () ->
        timeAtThisFrame = new Date().getTime()
        timeSinceLastDoLogic = (timeAtThisFrame - @timeAtLastFrame) + @leftover;
        catchUpFrameCount = Math.floor(timeSinceLastDoLogic / @step);
        i = 0
        while i < catchUpFrameCount
            @updateLogic()
            @updateScore()
            @frame += 1
            i++

        @leftover = timeSinceLastDoLogic - (catchUpFrameCount * @step);
        @timeAtLastFrame = timeAtThisFrame;

    updateScore: () ->
        score = $('#score')
        score.find('.alive').text(@world.maxAlive)
        score.find('.age').text(@world.maxAge)
        score.find('.tiles').text(@placed)
        @score = Math.round @world.maxAlive * @world.maxAge / (Math.sqrt(@placed)) || 0
        score.find('.total').text(@score)

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
        if @selectedTile == Cell.Life
            @gameMode()

    finish: () ->
        @world.finished = true

    showFinishMenu: () ->
        $('#finish').show()

    updateLogic: () ->
        if @world.finished
            @pause = true
            @showFinishMenu()
            @world.finished = false
        if !@pause
            @world.step()

$ ->
    window.game = new Game()
    game.start()
