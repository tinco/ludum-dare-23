

class Keyboard
    constructor: (game,graphics) ->
        @graphics = graphics
        @g = game
        @center = new THREE.Vector3(0,0,0)
        @angle = Math.TAU / 20
        @target
        @speed = 0
        @dir

    start: () ->
        @c = @graphics.camera
        @p = @c.position
        key 'w', => @rotate "X-"
        key 'a', => @rotate "Y-"
        key 's', => @rotate "X+"
        key 'd', => @rotate "Y+"
        key 'p', => @g.pause = !@g.pause
        
    rotate: (dir) ->
        @speed = 1
        @dir = dir
        if @dir is "X-"
            @g.piece.y-=1
            @rotX(@g.piece.position,-@angle)
            @rotX(@p,-@angle)
        else if @dir is "X+"
            @g.piece.y+=1
            @rotX(@g.piece.position,@angle)
            @rotX(@p,@angle)
        else if @dir is "Y-"
            @g.piece.x-=1
            @rotY(@g.piece.position,-@angle)
            @rotY(@p,-@angle)
        else if @dir is "Y+"
            @g.piece.x+=1
            @rotY(@g.piece.position,@angle)
            @rotY(@p,@angle)
        @c.lookAt(@center)
        @g.piece.rotation = @c.rotation.clone()
            
        
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