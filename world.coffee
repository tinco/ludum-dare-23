class World
    @RADIUS = 50
    @CIRCUMFERENCE = 35
    @HEIGHT = 11
    @ANGLE = Math.TAU / @CIRCUMFERENCE
    @SIZE = @ANGLE * @RADIUS
    @CENTER = new THREE.Vector3(0,0,0)

    constructor: () ->
        @createMesh()
        @world = @createEmptyWorld()
        @loadTerrain()

    loadTerrain: () ->
        @earthify(i,j) for i in [0..7] for j in [0..7]
        @seedify(i,j) for i in [1..2] for j in [1..2]
        @seedify(i,j) for i in [5..6] for j in [5..6]
        

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

    step: () ->
        for row in @world
            for cell in row
                cell.step()
        for row in @world
            for cell in row
                cell.finishStep()

    earthify: (r,c) ->
        p = new Cell(@world, r, c, Cell.Earth)
        @world[r][c] = p
        
    seedify: (r, c) ->
        p = new Cell(@world, r, c, Cell.Forest)
        @world[r][c] = p
        

    createMesh: () ->
        # create the sphere's material
        sphereMaterial = new THREE.MeshLambertMaterial(color: 0xCC0000)

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
