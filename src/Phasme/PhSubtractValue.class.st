Class {
	#name : #PhSubtractValue,
	#superclass : #PhInstruction,
	#instVars : [
		'value',
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhSubtractValue class >> value: aLiteral destination: aRegister [

	^ self new
		value: aLiteral;
		destination: aRegister;
		yourself
]

{ #category : #accessing }
PhSubtractValue >> destination [

	^ destination
]

{ #category : #accessing }
PhSubtractValue >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhSubtractValue >> value [

	^ value
]

{ #category : #accessing }
PhSubtractValue >> value: anObject [

	value := anObject
]

{ #category : #accessing }
PhSubtractValue >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'sub $';
		nextPutAll: value asString;
		nextPutAll: ', %';
		nextPutAll: destination
]
