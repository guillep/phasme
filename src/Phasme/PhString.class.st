Class {
	#name : #PhString,
	#superclass : #PhInstruction,
	#instVars : [
		'id',
		'value'
	],
	#category : #'Phasme-IR'
}

{ #category : #accessing }
PhString class >> id: anId value: aValue [

	^ self new
		id: anId;
		value: aValue;
		yourself
]

{ #category : #accessing }
PhString >> id [

	^ id
]

{ #category : #accessing }
PhString >> id: anObject [

	id := anObject
]

{ #category : #accessing }
PhString >> label [

	^ '.L.', id asString
]

{ #category : #accessing }
PhString >> value [

	^ value
]

{ #category : #accessing }
PhString >> value: anObject [

	value := anObject
]

{ #category : #accessing }
PhString >> writeInDataSectionOnStream: aWriteStream [

	aWriteStream
		nextPutAll: self label;
		nextPutAll: ': .asciz "';
		nextPutAll: value asString;
		nextPutAll: '"';
		cr;
		cr
]
