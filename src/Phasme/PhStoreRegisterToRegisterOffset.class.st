Class {
	#name : #PhStoreRegisterToRegisterOffset,
	#superclass : #PhInstruction,
	#instVars : [
		'source',
		'base',
		'offset'
	],
	#category : #'Phasme-IR'
}

{ #category : #accessing }
PhStoreRegisterToRegisterOffset >> base [

	^ base
]

{ #category : #accessing }
PhStoreRegisterToRegisterOffset >> base: anObject [

	base := anObject
]

{ #category : #accessing }
PhStoreRegisterToRegisterOffset >> offset [

	^ offset
]

{ #category : #accessing }
PhStoreRegisterToRegisterOffset >> offset: anObject [

	offset := anObject
]

{ #category : #accessing }
PhStoreRegisterToRegisterOffset >> source [

	^ source
]

{ #category : #accessing }
PhStoreRegisterToRegisterOffset >> source: anObject [

	source := anObject
]

{ #category : #'writing - text' }
PhStoreRegisterToRegisterOffset >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'movq %';
		nextPutAll: source;
		nextPutAll: ', ';
		nextPutAll: offset asString;
		nextPutAll: '(%';
		nextPutAll: base asString;
		nextPutAll: ')'
]
