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
        neighbours = {}
        for coord in coordinates
            cell = null
            row = @world[coord[0]]
            if row?
                cell = row[coord[1]]
            if cell?
                neighbours[cell.constructor] ?= []
                neighbours[cell.constructor].push cell
        neighbours

class EmptyCell extends Cell
    step: (newWorld) ->
        if @neighbours()[PopulatedCell]?.length == 3
            newWorld[@row][@column] = new PopulatedCell(newWorld, @row, @column)
        else
            @world = newWorld

class PopulatedCell extends Cell
    step: (newWorld) ->
        neighbours = @neighbours()
        if neighbours[PopulatedCell]?.length > 3
            #console.debug "die of overpopulation"
            newWorld[@row][@column] = new EmptyCell(newWorld, @row, @column)
        else if neighbours[PopulatedCell]?.length < 2
            #console.debug "die of underpopulation"
            newWorld[@row][@column] = new EmptyCell(newWorld, @row, @column)
        else if not neighbours[PopulatedCell]?
            #console.debug "die of underpopulation"
            newWorld[@row][@column] = new EmptyCell(newWorld, @row, @column)
        else
            #console.debug "survive"
            @world = newWorld
