initialized = false
dim = 1024
d2 = dim * dim

NNoise = 30000
noiseVals = [NNoise]
NWalkDistance = 30
NMinStep = 1
NWalk = 2000
noiseWalk = [NWalk]

(doOnce = ->
	currentTime = new Date()
	t1 = currentTime.getTime()	

	initialized = true
	i=0
	while (i < NNoise) 
		rval = Math.random()
		if (i < NWalk)
			noiseWalk[i] = Math.round(rval * NWalkDistance + NMinStep) 
		noiseVals[i++] = Math.round(rval * 255)
	console.log 'init time', currentTime.getTime() - t1
)()


$ ->

	canvas = window.document.getElementById("bkgCanvas")
	console.log canvas


	if canvas and canvas.getContext
		iWidth = iHeight = dim
		screenWidth = $(window).width()
		screenHeight = $(window).height()
		scaleWidth = $(window).width()/iWidth
		scaleHeight = $(window).height()/iHeight

		canvas.width = iWidth
		canvas.height = iHeight

		ctx = canvas.getContext("2d")
		id = ctx.getImageData(0, 0, iWidth, iHeight) 
		b = id.data

		currentTime = new Date()
		t1 = currentTime.getTime()	

		i = iNoise = iNoiseWalk = 0;
		while (i < d2)
			j = i * 4
			# console.log 'noising j',j,'val',noiseVals[iNoise]
			b[j] = b[j+1] = b[j+2] = noiseVals[iNoise]
			b[j+3] = 255
			iNoise++
			iNoise = 0 if (iNoise >= NNoise) # cycle
			iNoiseWalk++
			iNoiseWalk = 0 if (iNoiseWalk >= NWalk)
			i += noiseWalk[iNoiseWalk]
		ctx.putImageData id, 0, 0
		console.log 'total time',currentTime.getTime() - t1
