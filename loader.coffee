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
                window[newClass.name][k] = v
    else
        window[newClass.name] = newClass

refreshClass = (name, callback) ->
    downloadClass '/assets/' + name + '.js', (c)->
        updateClass(c)
        callback()

$ ->
    refresher = () -> refreshClass('game', () -> setTimeout(refresher,1000))
    refresher()
