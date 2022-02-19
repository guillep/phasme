Class {
	#name : #PhLoadRegisterOffset,
	#superclass : #PhInstruction,
	#instVars : [
		'base',
		'offset',
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #accessing }
PhLoadRegisterOffset >> base [

	^ base
]

{ #category : #accessing }
PhLoadRegisterOffset >> base: anObject [

	base := anObject
]

{ #category : #accessing }
PhLoadRegisterOffset >> destination [

	^ destination
]

{ #category : #accessing }
PhLoadRegisterOffset >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhLoadRegisterOffset >> offset [

	^ offset
]

{ #category : #accessing }
PhLoadRegisterOffset >> offset: anObject [

	offset := anObject
]

{ #category : #'writing - text' }
PhLoadRegisterOffset >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'movq ';
		nextPutAll: offset asString;
		nextPutAll: '(%';
		nextPutAll: base asString;
		nextPutAll: '), %';
		nextPutAll: destination
]
