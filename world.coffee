class World
    @RADIUS = 50
    @CIRCUMFERENCE = 35
    @HEIGHT = 11
    @ANGLE = Math.TAU / @CIRCUMFERENCE
    @SIZE = @ANGLE * @RADIUS
    @CENTER = new THREE.Vector3(0,0,0)

    constructor: () ->
        @createMesh()
        @initialize()
        @alive = []
        @maxAlive = 0
        @maxAge = 0

    initialize: () ->
        @world = @createEmptyWorld()

    debug: (world) ->
        for row in (world || @world)
            line = ""
            for c in row
                line += c.kind
            console.debug line

    createEmptyWorld: () ->
        @world = []
        createRow = (r)=>
            row = (new Cell(@world,r,c) for c in [0..(World.CIRCUMFERENCE - 1)])
            @world.push row
            row
        (createRow(r) for r in [0..(World.HEIGHT - 1)])

    saveState: () ->
        state = []
        state.push(((if cell.kind == Cell.Life then Cell.Earth else cell.kind) for cell,c in row)) for row,r in @world
        state

    loadState: (state) ->
        for row, r in state
            for kind, c in row
                @changeTile(r,c,kind)

    reset: () ->
        @maxAlive = 0
        @maxAge = 0
        for row,r in @world
            for cell,c in row
                @changeTile(r,c, Cell.Water)

    step: () ->
        @alive = []
        for row in @world
            for cell in row
                cell.step()
        for row in @world
            for cell in row
                cell.finishStep()
                if cell.kind == Cell.Life
                    @maxAge = cell.age if cell.age > @maxAge
                    @alive.push cell
        @finished = @alive.length == 0
        @maxAlive = @alive.length if @alive.length > @maxAlive

    changeTile: (r, c, kind) ->
        cell = @world[r][c]
        dirty = kind != cell.kind
        if dirty
            @world[r][c].kind = @world[r][c].newKind = kind
            @world[r][c].updateMesh()

    createMesh: () ->
        # create the sphere's material
        texture = THREE.ImageUtils.loadTexture('assets/poles.png')
        sphereMaterial = new THREE.MeshLambertMaterial(map: texture)

        # create a new mesh with
        # sphere geometry - we will cover
        # the sphereMaterial next!
        sphere = new THREE.Mesh(
            new THREE.SphereGeometry(
                World.RADIUS,
                100,
                100),
                sphereMaterial);
        @mesh = sphere
