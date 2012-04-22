class World
    WORLD_RADIUS = 50
    WORLD_CIRCUMFERENCE = 20
    WORLD_HEIGHT = 10

    constructor: () ->
        @createMesh()
        @world = ((new EmptyCell() for j in [0..(WORLD_CIRCUMFERENCE - 1)]) for i in [1..WORLD_HEIGHT])

    step: () ->

    createMesh: () ->
        # create the sphere's material
        sphereMaterial = new THREE.MeshLambertMaterial(color: 0xCC0000)

        # create a new mesh with
        # sphere geometry - we will cover
        # the sphereMaterial next!
        sphere = new THREE.Mesh(
            new THREE.SphereGeometry(
                WORLD_RADIUS,
                100,
                100),
                sphereMaterial);
        @mesh = sphere
