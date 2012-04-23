class Audio
    constructor: () ->
        @context = new webkitAudioContext()
        @sounds =
            rimshot:
                url: "assets/rimshot.wav"
                buffer: null
            kick:
                url: "assets/kick.wav"
                buffer: null
            snare:
                url: "assets/snare.wav"
                buffer: null
            hihat:
                url: "assets/hihat.wav"
                buffer: null
        @loadSounds()

    loadSounds: () ->
        toDownload = []
        for name,sound of @sounds
            toDownload.push sound

        download = () =>
            newSound = toDownload.shift()
            if newSound?
                request = new XMLHttpRequest()
                request.open('GET', newSound.url, true)
                request.responseType = "arraybuffer"
                request.onload = () =>
                    @context.decodeAudioData(request.response,
                        (buffer) ->
                            newSound.buffer = buffer
                            download()
                    )
                request.send()
        download()

    playSound: (name, time) ->
        @source = @context.createBufferSource()
        @source.buffer = @sounds[name].buffer
        @source.connect(@context.destination)
        @source.noteOn(time)

    beat: () ->
        startTime = @context.currentTime + 0.100
        tempo = 80
        eighthNoteTime = (60 / tempo) / 2
        for bar in [0..2]
            time = startTime + bar * 8 * eighthNoteTime;
            
            @playSound("kick", time);
            @playSound("kick", time + 4 * eighthNoteTime);

            @playSound("snare", time + 2 * eighthNoteTime);
            @playSound("snare", time + 6 * eighthNoteTime);

            for i in [0..8]
                @playSound("hihat", time + i * eighthNoteTime);
