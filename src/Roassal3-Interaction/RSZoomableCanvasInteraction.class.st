"
I handle the zoom interaction with mouse wheel event, also I handle all the zoom process
"
Class {
	#name : #RSZoomableCanvasInteraction,
	#superclass : #RSAbstractControlCanvasInteraction,
	#instVars : [
		'animation'
	],
	#category : #'Roassal3-Interaction-Controls'
}

{ #category : #'events - processing' }
RSZoomableCanvasInteraction >> move: aCanvas evtPosition: evtPosition delta: delta [

	| camera sc dist correct scale position |
	camera := aCanvas camera.
	sc := camera scale * delta x.
	sc = (self scaleFor: sc) ifFalse: [ ^ self ].
	dist := evtPosition - camera position.
	correct := self
		correctCameraPosition: aCanvas 
		inRectangle: (self expandedRectangle: aCanvas)
		position: camera position + (dist * delta y)
		scale: sc.
	scale := NSScale sqrt range: { camera scale. sc }.
	position := NSScale sqrt range: { camera position. correct }.
	animation := aCanvas newAnimation
		duration: 200 milliSeconds;
		onStepDo: [ :t |
			camera 
				scale: (scale scale: t);
				translateTo: (position scale: t).
			aCanvas signalUpdate ];
		when: RSAnimationEndEvent do: [ animation := nil ]
]

{ #category : #hooks }
RSZoomableCanvasInteraction >> onShape: aCanvas [
	aCanvas when: RSMouseWheelEvent send: #processEvent: to: self.
]

{ #category : #'events - processing' }
RSZoomableCanvasInteraction >> processEvent: evt [
	| delta |
	animation ifNotNil: [ ^ self ].
	delta := evt isUp
		ifTrue: [ 1.25@0.2 ]
		ifFalse: [ 0.8@ -0.25 ].
	self move: evt canvas evtPosition: evt position delta: delta.
]

{ #category : #rendering }
RSZoomableCanvasInteraction >> renderLegendOn: lb [
	lb text: 'Wheel' description: 'To zoom in-out the view'.
]

{ #category : #rendering }
RSZoomableCanvasInteraction >> renderOn: lb [
	lb text: 'Wheel' description: 'To zoom in-out the view'.
]
