Class {
	#name : #PhTopLevelNode,
	#superclass : #Object,
	#instVars : [
		'definitions'
	],
	#category : #'Phasme-AST'
}

{ #category : #accessing }
PhTopLevelNode >> definitions [

	^ definitions
]

{ #category : #accessing }
PhTopLevelNode >> definitions: anObject [

	definitions := anObject
]
