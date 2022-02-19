Class {
	#name : #PhReturn,
	#superclass : #PhInstruction,
	#category : #'Phasme-IR'
}

{ #category : #writing }
PhReturn >> writeInTextSectionOnStream: aWriteStream [
	
	aWriteStream tab; nextPutAll: 'ret'
]
