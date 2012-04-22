class Keyboard
    constructor: (game,graphics) ->
        @graphics = graphics
        @game = game
        @center = new THREE.Vector3(0,0,0)
        @angle = Math.TAU / World.CIRCUMFERENCE
        @target
        @speed = 0
        @dir

    start: () ->
        @c = @graphics.camera
        key 'w', => @rotate "X-"
        key 'a', => @rotate "Y-"
        key 's', => @rotate "X+"
        key 'd', => @rotate "Y+"
        key 'p', => @game.pause = !@game.pause

    rotate: (dir) ->
        @speed = 1
        @dir = dir
        #        if @dir is "X-"
        #
        #        else if @dir is "X+"
        #
        #        else if @dir is "Y-"
        #
        #        else if @dir is "Y+"

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
