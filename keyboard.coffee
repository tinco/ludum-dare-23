class Keyboard
    constructor: (game,graphics) ->
        @graphics = graphics
        @g = game
        @center = new THREE.Vector3(0,0,0)

    start: () ->
        @c = @graphics.camera
        @p = @c.position
        key('w', () => @rotate("X",-0.01))
        key('a', () => @rotate("Y",-0.01))
        key('s', () => @rotate("X",0.01))
        key('d', () => @rotate("Y",0.01))
        key('p', () => @g.pause = !@g.pause)

    rotate: (dir,val) ->
        if dir="X"
            @rotX(@p,val)
            @rotX(@g.piece.position,val)
        else
            @rotY(@p,val)
            @rotY(@g.piece.position,val)
        @c.lookAt(@center)
        @g.piece.rotation = @c.rotation.copy()
        
    rotX: (op,val) ->
        y = op.y*Math.cos(val) - op.z*Math.sin(val)
        z = op.y*Math.sin(val) + op.z*Math.cos(val)
        
        op.y = y
        op.z = z
    
    rotY: (val) ->
        x = op.x*Math.cos(val) + op.z*Math.sin(val)
        z = op.z*Math.cos(val) - op.x*Math.sin(val)
        op.x = x
        op.z = z