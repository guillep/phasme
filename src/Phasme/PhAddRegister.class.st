Class {
	#name : #PhAddRegister,
	#superclass : #PhInstruction,
	#instVars : [
		'source',
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhAddRegister class >> operand: operand destination: aRegister [

	^ self new
		source: operand;
		destination: aRegister;
		yourself
]

{ #category : #accessing }
PhAddRegister >> destination [

	^ destination
]

{ #category : #accessing }
PhAddRegister >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhAddRegister >> source [

	^ source
]

{ #category : #accessing }
PhAddRegister >> source: anObject [

	source := anObject
]

{ #category : #accessing }
PhAddRegister >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'add %';
		nextPutAll: source;
		nextPutAll: ', %';
		nextPutAll: destination
]
