class Audio
    @Sounds = 18 # Number of different piano sounds

    constructor: () ->
        @context = new webkitAudioContext()
        @sounds =
            rimshot:
                url: "assets/rimshot.wav"
            kick:
                url: "assets/kick.wav"
            snare:
                url: "assets/snare.wav"
            hihat:
                url: "assets/hihat.wav"
            0:
                url: "assets/a0.mp3"
            1:
                url: "assets/a2.mp3"
            2:
                url: "assets/a5.mp3"
            3:
                url: "assets/b0.mp3"
            4:
                url: "assets/b2.mp3"
            5:
                url: "assets/b5.mp3"
            6:
                url: "assets/d2.mp3"
            7:
                url: "assets/d3.mp3"
            8:
                url: "assets/d5.mp3"
            9:
                url: "assets/d6.mp3"
            10:
                url: "assets/e0.mp3"
            11:
                url: "assets/e2.mp3"
            12:
                url: "assets/e3.mp3"
            13:
                url: "assets/e5.mp3"
            14:
                url: "assets/e6.mp3"
            15:
                url: "assets/f-0.mp3"
            16:
                url: "assets/f-2.mp3"
            17:
                url: "assets/f-5.mp3"
        @compressor = @context.createDynamicsCompressor()
        @compressor.connect(@context.destination)
        @gain = @context.createGainNode()
        @gain.gain.value = 0.5
        @gain.connect(@compressor)
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
        
        @source.connect(@gain)
        
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
