Class {
	#name : #PhLoadValue,
	#superclass : #PhInstruction,
	#instVars : [
		'value',
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #'as yet unclassified' }
PhLoadValue class >> value: aLiteral intoRegister: aRegister [

	^ self new
		value: aLiteral;
		destination: aRegister;
		yourself
]

{ #category : #accessing }
PhLoadValue >> destination [

	^ destination
]

{ #category : #accessing }
PhLoadValue >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhLoadValue >> value [

	^ value
]

{ #category : #accessing }
PhLoadValue >> value: anObject [

	value := anObject
]

{ #category : #writing }
PhLoadValue >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'movq $';
		nextPutAll: value asString;
		nextPutAll: ', %';
		nextPutAll: destination
]
