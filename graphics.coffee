Math.TAU = 2 * Math.PI
class Graphics
    constructor: (game) ->
        @game = game
        @nastyCamera = new THREE.Camera()
        @frame = 0
        @viewport.width = document.body.clientWidth
        @viewport.height = document.body.clientHeight
        @cells = []
        
    initialize: () ->
        @setup()
        @loadScene()        
        
    start: () ->
        @initialize()
        @loop()
        
    loop: () ->
        @updateGraphics()
        TWEEN.update()
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
            new Camera(@game,
                @viewAngle,
                @viewport.width / @viewport.height,
                @focus.near, @focus.far)

        @renderer.setSize(@viewport.width, @viewport.height)

        # attach the render-supplied DOM element
        @container.append(@renderer.domElement)

    addToScene: (x,y, c) -> 
        p = c.mesh
        p.position.x = 0
        p.position.y = 0
        p.position.z = 1
        @rotX(p.position, y * World.ANGLE)
        @rotY(p.position, x * World.ANGLE)
        p.position.normalize().multiplyScalar(World.RADIUS+World.SIZE/2)
        # HOLY SHIT UGLY HACK, but it works
        @nastyCamera.position = p.position.clone()
        @nastyCamera.lookAt(World.CENTER)
        p.rotation = @nastyCamera.rotation.clone()
        @scene.add(p)
        @cells.push c

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
                @addToScene(c,r - (World.HEIGHT - 1) / 2,cell)