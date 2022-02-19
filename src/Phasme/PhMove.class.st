Class {
	#name : #PhMove,
	#superclass : #PhInstruction,
	#instVars : [
		'origin',
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #'as yet unclassified' }
PhMove class >> from: origin to: destination [

	^ self new
		origin: origin;
		destination: destination;
		yourself
]

{ #category : #accessing }
PhMove >> destination [

	^ destination
]

{ #category : #accessing }
PhMove >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhMove >> origin [

	^ origin
]

{ #category : #accessing }
PhMove >> origin: anObject [

	origin := anObject
]

{ #category : #writing }
PhMove >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'movq %';
		nextPutAll: origin asString;
		nextPutAll: ', %';
		nextPutAll: destination
]
