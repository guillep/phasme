Class {
	#name : #PhLiteralNode,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : #'Phasme-AST'
}

{ #category : #accessing }
PhLiteralNode class >> value: aLiteral [

	^ self new
		value: aLiteral;
		yourself
]

{ #category : #comparing }
PhLiteralNode >> = aNode [

	(aNode isKindOf: PhLiteralNode) ifFalse: [ ^ false ].
	^ value = aNode value
]

{ #category : #comparing }
PhLiteralNode >> hash [

	^ value hash
]

{ #category : #accessing }
PhLiteralNode >> value [

	^ value
]

{ #category : #accessing }
PhLiteralNode >> value: anObject [

	value := anObject
]
