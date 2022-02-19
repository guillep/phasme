Class {
	#name : #PhLabel,
	#superclass : #PhInstruction,
	#instVars : [
		'name',
		'isGlobal'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhLabel class >> name: aString [ 
	
	^ self new
		name: aString;
		yourself
]

{ #category : #building }
PhLabel >> beGlobal [
	
	isGlobal := true
]

{ #category : #building }
PhLabel >> initialize [
	
	super initialize.
	isGlobal := false
]

{ #category : #testing }
PhLabel >> isGlobal [
	^ isGlobal
]

{ #category : #accessing }
PhLabel >> name: aString [ 
	name := aString
]

{ #category : #declaring }
PhLabel >> writeInDataSectionOnStream: aWriteStream [ 
	
	self isGlobal ifTrue: [
		aWriteStream
			tab;
			nextPutAll: '.global ';
			nextPutAll: name asString;
			cr; cr
	]
]

{ #category : #writing }
PhLabel >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		nextPutAll: name;
		nextPutAll: ':'
]
