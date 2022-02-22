Class {
	#name : #PhMultiplyRegister,
	#superclass : #PhInstruction,
	#instVars : [
		'source',
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhMultiplyRegister class >> source: source destination: aRegister [

	^ self new
		source: source;
		destination: aRegister;
		yourself
]

{ #category : #accessing }
PhMultiplyRegister >> destination [

	^ destination
]

{ #category : #accessing }
PhMultiplyRegister >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhMultiplyRegister >> source [

	^ source
]

{ #category : #accessing }
PhMultiplyRegister >> source: anObject [

	source := anObject
]

{ #category : #accessing }
PhMultiplyRegister >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'imulq %';
		nextPutAll: source;
		nextPutAll: ', %';
		nextPutAll: destination
]
