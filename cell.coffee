class Cell
    constructor: (world, r, c) ->
        @world = world
        @row = r
        @column = c

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
        # row 1 column 2 is neighbour van row 0 column 2
        neighbours = {}
        for coord in coordinates
            cell = @world[coord[0]]?[coord[1]]
            if cell?
                neighbours[cell.constructor] ?= []
                neighbours[cell.constructor].push cell
        neighbours

class EmptyCell extends Cell
    step: (newWorld) ->
        if @neighbours()[PopulatedCell]?.length > 3
            console.debug "become alive"
            newWorld[@row][@column] = new PopulatedCell(@world, @row, @column)

class PopulatedCell extends Cell
    step: (newWorld) ->
        neighbours = @neighbours()
        if neighbours[PopulatedCell]?.length > 3 || neighbours[PopulatedCell]?.length < 2 || not neighbours[PopulatedCell]?
            newWorld[@row][@column] = new EmptyCell(@world, @row, @column)
