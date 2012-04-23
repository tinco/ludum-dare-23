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

    reset: () ->
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
                    @alive.push cell
        @finished = @alive.length == 0

    changeTile: (r, c, kind) ->
        cell = @world[r][c]
        dirty = kind != cell.kind
        if dirty
            @world[r][c].kind = @world[r][c].newKind = kind
            @world[r][c].updateMesh()

    createMesh: () ->
        # create the sphere's material
        sphereMaterial = new THREE.MeshLambertMaterial(color: 0x000000)

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
