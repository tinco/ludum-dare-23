Math.TAU = 2 * Math.PI

window.world_radius = 50
pieces_per_row = 20

piece_size = Math.TAU * (window.world_radius) / pieces_per_row

class Game
    constructor: () ->
        @frame = 0
        @graphics = new Graphics()
        @keyboard = new Keyboard(@,@graphics)
        @timeAtLastFrame = new Date().getTime()
        @leftover = 0.0
        @fps = 30
        @step = 1000 / @fps #ms
        @pieces = [[[]]]
        @pause = false
        
    loop: () ->
        t = this
        step = -> t.gameStep()
        setInterval(step, @step / 10)

    start: () ->
        @graphics.setup()
        @graphics.loadScene()
        @graphics.start()
        @keyboard.start()
        @started = true
        @newPiece()
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
        @piece.position.z -= .3 if !@pause
        if @piece.position.z < world_radius + piece_size / 2 or onPiece(@piece,@pieces[@piece.position.x][@piece.position.y])
            @pieces[@piece.position.x][@piece.position.y].push @piece
            @newPiece()

    newPiece: () ->
        @piece = new THREE.Mesh(
            new THREE.CubeGeometry(
                piece_size, piece_size, piece_size),
                new THREE.MeshLambertMaterial(
                    color: 0xCC0000))
        
        @graphics.addToScene(@piece)
        @piece.position.z = 150
    
    onPiece = (piece, pieces) ->
        for p in pieces
            if piece.position.z < p.position.z+piece_size
                return true
        return false
            
        
        