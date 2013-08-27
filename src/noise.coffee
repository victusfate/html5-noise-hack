initialized = false
dim = 1024
d2 = dim * dim

# caching noiseVals didn't appear to affect performance
# NNoise = 30000
# noiseVals = []
# noiseVals.length = NNoise
NWalkDistance = 60
NMinStep = 1
NWalk = 2000
noiseWalk = []
noiseWalk.length = NWalk

$ ->

    t1 = Date.now()  

    init = (cb) ->
        initialized = true
        i=0
        # while (i < NNoise) 
        while (i < NWalk) 
            rval = Math.random()
            # if (i < NWalk)
            noiseWalk[i++] = Math.round(rval * NWalkDistance + NMinStep) 
            # noiseVals[i++] = Math.round(rval * 255)
            # console.log 'setting noisevals, first 100',i,noiseVals[i-1] if i < 100
        console.log 'init time', Date.now() - t1
        cb()

    setCanvas = ->
        t2 = Date.now() 
        canvas = window.document.getElementById("bkgCanvas")
        if canvas and canvas.getContext
            ctx = canvas.getContext("2d")
            ctx.fillStyle   = '#000'
            ctx.fillRect 0,0,dim,dim
            id = ctx.getImageData(0, 0, dim, dim) 
            b = id.data

            i = 0
            # iNoise = Math.round(Math.random() * NNoise)
            iNoiseWalk = Math.round(Math.random() * NWalk)
            # console.log('offset iNoise,iNoiseWalk',iNoise,iNoiseWalk)
            while (i < d2)
                j = i * 4
                # console.log 'noising j',j,'val',noiseVals[iNoise]
                # b[j] = b[j+1] = b[j+2] = noiseVals[iNoise]
                b[j] = b[j+1] = b[j+2] = Math.round(Math.random()*255)
                b[j+3] = 255
                # console.log 'applying noise vals, first 100,i,iNoise,noiseVal',i,iNoise,noiseVals[iNoise],b[j],b[j+1],b[j+2],b[j+3] if i < 100

                # iNoise++
                # iNoise = 0 if (iNoise >= NNoise) # cycle
                iNoiseWalk++
                iNoiseWalk = 0 if (iNoiseWalk >= NWalk)
                i += noiseWalk[iNoiseWalk]
            ctx.putImageData id, 0, 0
            console.log 'total time',Date.now() - t1,'noise apply time',Date.now()-t2
            setTimeout =>
                setCanvas()
                false
            , 50
        return false

    init(setCanvas)        
