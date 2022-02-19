Class {
	#name : #PhPushValue,
	#superclass : #PhInstruction,
	#instVars : [
		'value'
	],
	#category : #'Phasme-IR'
}

{ #category : #accessing }
PhPushValue class >> value: aValue [

	^ self new
		value: aValue;
		yourself
]

{ #category : #accessing }
PhPushValue >> value [

	^ value
]

{ #category : #accessing }
PhPushValue >> value: anObject [

	value := anObject
]

{ #category : #writing }
PhPushValue >> writeInTextSectionOnStream: aWriteStream [

	aWriteStream
		tab;
		nextPutAll: 'push $';
		nextPutAll: value asString
]
