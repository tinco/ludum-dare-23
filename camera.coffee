class Camera extends THREE.PerspectiveCamera
    constructor: (row, column, rest...) ->
        super rest...
        @row = row
        @column = column

    moveLeft: () -> @rotY(@position,-World.ANGLE)
    moveRight: () -> @rotY(@position,World.ANGLE)
    moveUp: () -> @rotX(@position,-World.ANGLE)
    moveDown: () -> @rotX(@position,World.ANGLE)
    moveTo: (r,c) ->

    rotX: (op,val) ->
        y = op.y*Math.cos(val) - op.z*Math.sin(val)
        z = op.y*Math.sin(val) + op.z*Math.cos(val)
        op.y = y
        op.z = z
        @lookAt(World.CENTER)

    rotY: (op,val) ->
        x = op.x*Math.cos(val) + op.z*Math.sin(val)
        z = op.z*Math.cos(val) - op.x*Math.sin(val)
        op.x = x
        op.z = z
        @lookAt(World.CENTER)
