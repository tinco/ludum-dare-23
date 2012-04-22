Math.TAU = 2 * Math.PI
class Graphics
    constructor: (game) ->
        @game = game
        @nastyCamera = new THREE.Camera()
        @frame = 0
        @viewport.width = document.body.clientWidth
        @viewport.height = document.body.clientHeight
    start: () ->
        for row,r in @game.world.world
            for cell,c in row
                @addToScene(c,r-2,cell)
        @loop()
    loop: () ->
        @updateGraphics()
        @renderer.render(@scene, @camera)
        @frame += 1
        t = this
        requestAnimationFrame(() -> t.loop())
    viewport: {width: 400, height: 300}
    focus: {near : 0.1, far : 10000}
    viewAngle: 45
    speed: 1/10
    updateGraphics: ->
    setup: () ->
        # get the DOM element to attach to
        # - assume we've got jQuery to hand
        @container = $('#container')

        # create a WebGL renderer, camera
        # and a scene
        @renderer = new THREE.WebGLRenderer()
        @camera =
            new THREE.PerspectiveCamera(
                @viewAngle,
                @viewport.width / @viewport.height,
                @focus.near, @focus.far)

        @renderer.setSize(@viewport.width, @viewport.height)

        # attach the render-supplied DOM element
        @container.append(@renderer.domElement)

    addToScene: (x,y, c) -> 
        #p = new THREE.Mesh(new THREE.CubeGeometry(World.SIZE,World.SIZE,World.SIZE),new THREE.MeshLambertMaterial(color: 0xCC00FF))
        p = c.mesh
        p.position.x = 0
        p.position.y = 0
        p.position.z = 1
        @rotX(p.position, y * World.ANGLE)
        @rotY(p.position, x * World.ANGLE)
        p.position.normalize().multiplyScalar(World.RADIUS+World.SIZE/2)
        # HOLY SHIT LELIJKE HACK, maar het werkt
        @nastyCamera.position = p.position.clone()
        @nastyCamera.lookAt(World.CENTER)
        p.rotation = @nastyCamera.rotation.clone()
        @scene.add(p)
        
    rotX: (op,val) ->
        y = op.y*Math.cos(val) - op.z*Math.sin(val)
        z = op.y*Math.sin(val) + op.z*Math.cos(val)
        op.y = y
        op.z = z

    rotY: (op,val) ->
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

        # the camera starts at 0,0,0
        # so pull it back
        @camera.position.z = 250

        #create a point light
        pointLight = new THREE.PointLight(0xFFFFFF);

        # set its position
        pointLight.position.x = 10
        pointLight.position.y = 50
        pointLight.position.z = 130

        # add to the scene
        scene.add(pointLight)
        @scene = scene
