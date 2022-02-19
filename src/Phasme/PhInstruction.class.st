Class {
	#name : #PhInstruction,
	#superclass : #Object,
	#category : #'Phasme-IR'
}

{ #category : #declaring }
PhInstruction >> writeInDataSectionOnStream: aWriteStream [ 
	
	"Do nothing"
]

{ #category : #'writing - text' }
PhInstruction >> writeInTextSectionOnStream: aWriteStream [ 
	
	self subclassResponsibility
]
