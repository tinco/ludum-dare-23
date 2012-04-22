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
        @step = 1000 / @fps # ms
        @pieces = []
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
        @newPiece(0,0)
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
            @piece.position.subSelf(@piece.position.clone().normalize().multiplyScalar(0.3))
            x = @piece.x
            y = @piece.y
            if @piece.position.distanceTo(new THREE.Vector3(0,0,0)) < window.world_radius + piece_size / 2 or onPiece(@piece)
                @pieces.push(@piece)
                @newPiece(x,y)

    newPiece: (x,y) ->
        @piece = new THREE.Mesh(
            new THREE.CubeGeometry(
                piece_size, piece_size, piece_size),
                new THREE.MeshLambertMaterial(
                    color: 0xCC0000))
        
        @piece.rotation = @graphics.camera.rotation.clone()
        @piece.position = @graphics.camera.position.clone().normalize().multiplyScalar(150)
        @piece.x = x
        @piece.y = y
        @graphics.addToScene(@piece)
    
    onPiece = (piece) ->
        for p in @pieces
            if piece.position.distanceTo(p.position) < piece_size
                return true
        return false
            