class Cell
    @Empty = 0
    @Populated = 1

    constructor: (world, r, c, kind) ->
        @world = world
        @row = r
        @column = c
        @kind = kind || Cell.Empty
        @newKind = @kind
        @mesh = new THREE.Mesh(new THREE.CubeGeometry(World.SIZE,World.SIZE,World.SIZE),new THREE.MeshLambertMaterial(color: 0xCC00FF))

    neighbours: () ->
        left = @column - 1
        right = @column + 1
        if @column == 0
            left = World.CIRCUMFERENCE - 1
        if @column == World.CIRCUMFERENCE - 1
            right = 0
        above = @row + 1
        under = @row - 1
        coordinates = [
         [@row, left],
         [@row, right],
         [above, left],
         [above, right],
         [above, @column],
         [under, @column],
         [under, left],
         [under, right]
        ]
        neighbours = {}
        for coord in coordinates
            cell = null
            row = @world[coord[0]]
            if row?
                cell = row[coord[1]]
            if cell?
                neighbours[cell.kind] ?= []
                neighbours[cell.kind].push cell
        neighbours

    step: () ->
        switch @kind
            when Cell.Empty
                if @neighbours()[Cell.Populated]?.length == 3
                    @newKind = Cell.Populated
            when Cell.Populated
                neighbours = @neighbours()
                if neighbours[Cell.Populated]?.length > 3
                    @newKind = Cell.Empty
                else if neighbours[Cell.Populated]?.length < 2
                    @newKind = Cell.Empty
                else if not neighbours[Cell.Populated]?
                    @newKind = Cell.Empty

    finishStep: () ->
        @kind = @newKind
