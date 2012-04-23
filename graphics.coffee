Math.TAU = 2 * Math.PI
class Graphics
    constructor: (game) ->
        @game = game
        @nastyCamera = new THREE.Camera()
        @frame = 0
        @cells = []

    initialize: () ->
        @setup()
        @loadScene()

    start: () ->
        @initialize()
        @camera.showSelection()
        @loop()

    loop: () ->
        @updateGraphics()
        TWEEN.update()
        @renderer.render(@scene, @camera)
        @frame += 1
        t = this
        requestAnimationFrame(() -> t.loop())

    focus: {near : 0.1, far : 10000}
    viewAngle: 45
    speed: 1/10

    updateGraphics: ->

    setup: () ->
        # get the DOM element to attach to
        # - assume we've got jQuery to hand
        @container = $('#container')
        @viewport = {}
        @viewport.width = @container.width()
        @viewport.height = @container.height()

        # create a WebGL renderer, camera
        # and a scene
        @renderer = new THREE.WebGLRenderer(antialias: true)
        @camera =
            new Camera(@game,
                @viewAngle,
                @viewport.width / @viewport.height,
                @focus.near, @focus.far)

        @renderer.setSize(@viewport.width, @viewport.height)

        # attach the render-supplied DOM element
        @container.append(@renderer.domElement)

    addToScene: (cell) ->
        cell.mesh.position = @calculatePosition(cell.row, cell.column, Cell.Distance)
        cell.mesh.rotation = @calculateRotation(cell.mesh.position)
        @scene.add(cell.mesh)
        @cells.push cell

    calculatePosition: (r,c, distance) ->
        newPosition = new THREE.Vector3()
        newPosition.x = 0
        newPosition.y = 0
        newPosition.z = 1
        @rotY(newPosition, (r - (World.HEIGHT - 1) / 2) * World.ANGLE)
        @rotX(newPosition, c * World.ANGLE)
        newPosition.normalize().multiplyScalar(distance)
        newPosition

    calculateRotation: (position) ->
        # HOLY SHIT UGLY HACK, but it works
        @nastyCamera.position = position.clone()
        @nastyCamera.lookAt(World.CENTER)
        @nastyCamera.rotation.clone()

    rotY: (op,val) ->
        y = op.y*Math.cos(val) - op.z*Math.sin(val)
        z = op.y*Math.sin(val) + op.z*Math.cos(val)
        op.y = y
        op.z = z

    rotX: (op,val) ->
        x = op.x*Math.cos(val) + op.z*Math.sin(val)
        z = op.z*Math.cos(val) - op.x*Math.sin(val)
        op.x = x
        op.z = z

    render: () ->
        @renderer.render(@scene, @camera)

    loadScene: () ->
        scene = new THREE.Scene()

        # add the camera to the scene
        scene.add(@camera)

        #create a point light
        pointLight = new THREE.PointLight(0xFFFFFF);

        # set its position
        pointLight.position.x = 10
        pointLight.position.y = 50
        pointLight.position.z = 130

        # add to the scene
        scene.add(pointLight)
        @scene = scene
        @scene.add(@game.world.mesh)
        @loadCells()
        
    loadCells: () ->
        for c in @cells
            @scene.remove c.mesh
        @cells = []
        for row,r in @game.world.world
            for cell,c in row
                @addToScene(cell)
