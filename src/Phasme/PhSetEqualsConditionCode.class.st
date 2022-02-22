Class {
	#name : #PhSetEqualsConditionCode,
	#superclass : #PhInstruction,
	#instVars : [
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #accessing }
PhSetEqualsConditionCode >> destination [

	^ destination
]

{ #category : #accessing }
PhSetEqualsConditionCode >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhSetEqualsConditionCode >> writeInTextSectionOnStream: aWriteStream [
	
	| byteDestination |
	byteDestination := destination = 'rax'
		ifTrue: [ 'al' ]
		ifFalse: [ self halt ].
	aWriteStream tab;
		nextPutAll: 'sete %';
		nextPutAll: byteDestination
]
