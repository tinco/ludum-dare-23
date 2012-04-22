class World
    @RADIUS = 50
    @CIRCUMFERENCE = 20
    @HEIGHT = 10

    constructor: () ->
        @createMesh()
        @world = @createEmptyWorld()

    createEmptyWorld: () ->
        @world = []
        createRow = (r)=>
            row = (new EmptyCell(@world,r,c) for c in [0..(World.CIRCUMFERENCE - 1)])
            @world.push row
            row
        (createRow(r) for r in [0..(World.HEIGHT - 1)])

    duplicateWorld: () ->
        ((@world[r][c] for c in [0..(World.CIRCUMFERENCE - 1)]) for r in [0..(World.HEIGHT - 1)])

    step: () ->
        new_world = @duplicateWorld()
        for row,r in @world
            for cell,c in row
                cell.step(new_world)
        @world = new_world

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
