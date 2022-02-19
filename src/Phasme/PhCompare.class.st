Class {
	#name : #PhCompare,
	#superclass : #PhInstruction,
	#instVars : [
		'value',
		'destination'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhCompare class >> value: aLiteral destination: aRegister [

	^ self new
		value: aLiteral;
		destination: aRegister;
		yourself
]

{ #category : #accessing }
PhCompare >> destination [

	^ destination
]

{ #category : #accessing }
PhCompare >> destination: anObject [

	destination := anObject
]

{ #category : #accessing }
PhCompare >> value [

	^ value
]

{ #category : #accessing }
PhCompare >> value: anObject [

	value := anObject
]

{ #category : #accessing }
PhCompare >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'cmp $';
		nextPutAll: value asString;
		nextPutAll: ', %';
		nextPutAll: destination
]
