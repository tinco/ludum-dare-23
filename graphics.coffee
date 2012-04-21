class Graphics
    constructor: () ->
        @frame = 0
    start: () ->
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
        @sphere.position.setX(Math.sin(@frame * @speed) * 15)
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

    render: () ->
        @renderer.render(@scene, @camera)

    loadScene: () ->
        scene = new THREE.Scene()

        # add the camera to the scene
        scene.add(@camera)

        # the camera starts at 0,0,0
        # so pull it back
        @camera.position.z = 300

        # set up the sphere vars
        radius = 50
        segments = 16
        rings = 16

		#create the sphere's material
        sphereMaterial = new THREE.MeshLambertMaterial(color: 0xCC0000)
		
        # create a new mesh with
        # sphere geometry - we will cover
        # the sphereMaterial next!
        sphere = new THREE.Mesh(
            new THREE.SphereGeometry(
                radius,
                segments,
                rings),
                sphereMaterial);

        # add the sphere to the scene
        scene.add(sphere);

        #create a point light
        pointLight = new THREE.PointLight(0xFFFFFF);

        # set its position
        pointLight.position.x = 10
        pointLight.position.y = 50
        pointLight.position.z = 130

        # add to the scene
        scene.add(pointLight)
        @scene = scene
        @sphere = sphere
