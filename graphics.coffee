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
        @camera.updateSelectionPosition()
        @loop()

    loop: () ->
        @updateGraphics()
        TWEEN.update()
        @renderer.render(@scene, @camera)
        @frame += 1
        requestAnimationFrame(() => @loop())

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
        
        sunMaterial = new THREE.MeshLambertMaterial(color: 0xDDDD33)
        
        sun = new THREE.Mesh(
            new THREE.SphereGeometry(
                World.RADIUS*2,
                100,
                100),
                sunMaterial);
        sun.position.x = 10
        sun.position.y = 50
        sun.position.z = 2000
        
        texture = THREE.ImageUtils.loadTexture('assets/moon.png')
        moonMaterial = new THREE.MeshLambertMaterial
            map: texture,
            reflectivity: 0,
            specular: 0
        
        moon = new THREE.Mesh(
            new THREE.SphereGeometry(
                World.RADIUS,
                100,
                100),
                moonMaterial);
        moon.position.x = 200
        moon.position.y = 100
        moon.position.z = -400
        
        # create a point light
        moonLight = new THREE.PointLight(0xFFFFFF,0.4);
        # set its position
        moonLight.position.x = 150
        moonLight.position.y = 50
        moonLight.position.z = -350

        # create a point light
        spotLight = new THREE.SpotLight(0xFFC0B0, 3, 300, Math.TAU / 8);
        # set its position
        spotLight.position.x = 0
        spotLight.position.y = 50
        spotLight.position.z = 1700
        spotLight.lookAt(sun.position)
        
        pointLight = new THREE.PointLight(0xFFFFFF,0.8)
        faintLight = new THREE.PointLight(0xFFFFFF,0.2)
        faintLight.position.x = -200
        
        pointLight.position = spotLight.position.clone()
        
        # add to the scene
        scene.add(moon)
        scene.add(moonLight)
        scene.add(spotLight)
        scene.add(pointLight)
        scene.add(faintLight)
        
        startex = THREE.ImageUtils.loadTexture('assets/startex.jpg')
        starMaterial = new THREE.MeshBasicMaterial(map: startex)
        stars = new THREE.Mesh(new THREE.SphereGeometry(2300,100,100), starMaterial)
        stars.flipSided = true
        scene.add(stars)
        
        scene.add(sun)
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
