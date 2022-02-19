Class {
	#name : #PhLoadReference,
	#superclass : #PhInstruction,
	#instVars : [
		'reference',
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhLoadReference class >> reference: aReference intoRegister: aRegister [

	^ self new
		reference: aReference;
		destination: aRegister;
		yourself
]

{ #category : #accessing }
PhLoadReference >> destination [

	^ destination
]

{ #category : #accessing }
PhLoadReference >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhLoadReference >> reference [

	^ reference
]

{ #category : #accessing }
PhLoadReference >> reference: anObject [

	reference := anObject
]

{ #category : #writing }
PhLoadReference >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'lea ';
		nextPutAll: reference label;
		nextPutAll: '(%rip), %';
		nextPutAll: destination
]
