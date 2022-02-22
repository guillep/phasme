Class {
	#name : #PhSubtractRegister,
	#superclass : #PhInstruction,
	#instVars : [
		'source',
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhSubtractRegister class >> source: source destination: aRegister [

	^ self new
		source: source;
		destination: aRegister;
		yourself
]

{ #category : #accessing }
PhSubtractRegister >> destination [

	^ destination
]

{ #category : #accessing }
PhSubtractRegister >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhSubtractRegister >> source [

	^ source
]

{ #category : #accessing }
PhSubtractRegister >> source: anObject [

	source := anObject
]

{ #category : #accessing }
PhSubtractRegister >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'sub %';
		nextPutAll: source;
		nextPutAll: ', %';
		nextPutAll: destination
]
