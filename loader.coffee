downloadClass = (uri, callback) ->
    xhr = new XMLHttpRequest()
    xhr.open('GET', uri)
    xhr.responseType = 'text'
    xhr.onload = (e) ->
        if this.status == 200
            callback(eval(this.response))
    xhr.send()

updateClass = (newClass) ->
    if window[newClass.name]
        for k,v of newClass.prototype
            if newClass.prototype.hasOwnProperty(k)
                window[newClass.name].prototype[k] = v
    else
        window[newClass.name] = newClass

refreshClass = (name, callback) ->
    downloadClass '/assets/' + name + '.js', (c)->
        updateClass(c)
        callback()

$ ->
    gameRefresher = () ->
        refreshClass('game', () -> setTimeout(gameRefresher,1000))
    graphicsRefresher = () ->
        refreshClass('graphics', () -> setTimeout(graphicsRefresher,1000))
    worldRefresher = () ->
        refreshClass('world', () -> setTimeout(worldRefresher,1000))
    cellRefresher = () ->
        refreshClass('cell', () -> setTimeout(cellRefresher,1000))
    keyboardRefresher = () ->
        refreshClass('keyboard', () -> setTimeout(keyboardRefresher,1000))
    refreshClass 'game', () ->
        refreshClass 'graphics', () ->
            window.game = new Game()
            game.start()

    refreshers = ->
        gameRefresher()
        graphicsRefresher()
        worldRefresher()
        cellRefresher()
        keyboardRefresher()

    setTimeout(refreshers, 1000)

