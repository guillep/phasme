Class {
	#name : #PhAddValue,
	#superclass : #PhInstruction,
	#instVars : [
		'value',
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhAddValue class >> value: aLiteral destination: aRegister [

	^ self new
		value: aLiteral;
		destination: aRegister;
		yourself
]

{ #category : #accessing }
PhAddValue >> destination [

	^ destination
]

{ #category : #accessing }
PhAddValue >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhAddValue >> value [

	^ value
]

{ #category : #accessing }
PhAddValue >> value: anObject [

	value := anObject
]

{ #category : #accessing }
PhAddValue >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'add $';
		nextPutAll: value asString;
		nextPutAll: ', %';
		nextPutAll: destination
]
