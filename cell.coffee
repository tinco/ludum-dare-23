class Cell
    @Size = World.ANGLE * World.RADIUS
    @Distance = World.RADIUS + World.SIZE / 2
    @Height = 1

    @Water = 0
    @Earth = 1
    @Grass = 2
    @Forest =3
    @Life = 4

    @Kinds =
        0: 'Water',
        1: 'Earth',
        2: 'Grass',
        3: 'Forest',
        4: 'Life'

    @KindsAmount = 5

    constructor: (world, r, c, kind) ->
        @world = world
        @row = r
        @column = c
        @age = 0
        @kind = kind || Cell.Water
        @newKind = @kind
        @mesh = new THREE.Mesh(
            new THREE.CubeGeometry(Cell.Size,
                                   Cell.Size,
                                   Cell.Height))
        @materials = {}
        @materials[Cell.Water] = new THREE.MeshLambertMaterial(color: 0x00BFFF)
        @materials[Cell.Earth] = new THREE.MeshLambertMaterial(color: 0xA0522D)
        @materials[Cell.Grass] = new THREE.MeshLambertMaterial(color: 0x7CFC00)
        @materials[Cell.Forest] = new THREE.MeshLambertMaterial(color: 0x006400)
        @materials[Cell.Life] = new THREE.MeshLambertMaterial(color: 0xFFA500)
        @updateMesh()

    updateMesh: () ->
        @mesh.material = @materials[@kind]

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
        n = @neighbours()
        age = 0
        if n[Cell.Life]?.length > 0
            for c in n[Cell.Life] 
                if c.age > age
                    age = c.age
                
        if @kind == Cell.Life
            @age++
        else
            @age = 0
        switch @kind
            when Cell.Water
                if n[Cell.Life]?.length > 0 and age > 2
                    @newKind = Cell.Earth
            when Cell.Earth
                if n[Cell.Water]?.length > 0
                    @newKind = Cell.Grass
                if n[Cell.Earth]?.length == 8
                    @newKind = Cell.Water
            when Cell.Grass
                if n[Cell.Life]?.length > 0 and n[Cell.Water]?.length > 0
                    @newKind = Cell.Forest
                else if n[Cell.Water] is undefined
                    @newKind = Cell.Earth
            when Cell.Forest
                if n[Cell.Life]?.length > 0 and age > 2
                    @newKind = Cell.Life
            when Cell.Life
                if n[Cell.Water] is undefined
                    @newKind = Cell.Earth
                if n[Cell.Forest] is undefined 
                    @newKind = Cell.Grass
            

    finishStep: () ->
        if @kind != @newKind
            @kind = @newKind
            @updateMesh()
