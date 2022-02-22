Class {
	#name : #PhCompareRegisters,
	#superclass : #PhInstruction,
	#instVars : [
		'register1',
		'register2'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhCompareRegisters class >> register1: register1 register2: register2 [

	^ self new
		register1: register1;
		register2: register2;
		yourself
]

{ #category : #accessing }
PhCompareRegisters >> register1 [

	^ register1
]

{ #category : #accessing }
PhCompareRegisters >> register1: anObject [

	register1 := anObject
]

{ #category : #accessing }
PhCompareRegisters >> register2 [

	^ register2
]

{ #category : #accessing }
PhCompareRegisters >> register2: anObject [

	register2 := anObject
]

{ #category : #accessing }
PhCompareRegisters >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'cmp %';
		nextPutAll: register1;
		nextPutAll: ', %';
		nextPutAll: register2
]
