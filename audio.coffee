class Audio
    constructor: () ->
        @context = new webkitAudioContext()
        @buffer = null
        @loadSound("assets/rimshot.wav")
    
    loadSound: (url) ->
        request = new XMLHttpRequest()
        request.open('GET', url, true)
        request.responseType = "arraybuffer"
        request.onload = () =>
            @context.decodeAudioData(request.response, 
                (buffer) => @buffer = buffer)
        request.send()

    playSound: (buffer, time) ->
        @source = @context.createBufferSource()
        @source.buffer = buffer
        @source.connect(@context.destination)
        @source.noteOn(time)