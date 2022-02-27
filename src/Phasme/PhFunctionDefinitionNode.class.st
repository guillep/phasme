Class {
	#name : #PhFunctionDefinitionNode,
	#superclass : #Object,
	#instVars : [
		'name',
		'parameters',
		'statements'
	],
	#category : #'Phasme-AST'
}

{ #category : #accessing }
PhFunctionDefinitionNode >> name [

	^ name
]

{ #category : #accessing }
PhFunctionDefinitionNode >> name: anObject [

	name := anObject
]

{ #category : #accessing }
PhFunctionDefinitionNode >> parameters [

	^ parameters
]

{ #category : #accessing }
PhFunctionDefinitionNode >> parameters: anObject [

	parameters := anObject
]

{ #category : #accessing }
PhFunctionDefinitionNode >> statements [

	^ statements
]

{ #category : #accessing }
PhFunctionDefinitionNode >> statements: anObject [

	statements := anObject
]
