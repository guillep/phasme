Class {
	#name : #PhSimpleCompilerTests,
	#superclass : #TestCase,
	#category : #'Phasme-Tests'
}

{ #category : #tests }
PhSimpleCompilerTests >> compile: pharoMethodSource [

	^ PhPharoCompiler compileMethod: pharoMethodSource.
	
]

{ #category : #tests }
PhSimpleCompilerTests >> execute: compiledPhasme [
	
	| simulator |
	simulator := PhASMSimulator on: compiledPhasme.
	simulator run.

	"Return value"
	^ simulator rax
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileArithmetics [

	| program result |
	program := self compile: '_main ^ 1 + 2'.
	result := self execute: program.
	self assert: result equals: 3
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileImplicitReturn [

	| program result |
	program := self compile: '_main'.
	result := self execute: program.
	self assert: result equals: 0
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileLocalVariables [

	| program result |
	program := self compile: '_main | a | 
		a := 2.
		^ 1 + a'.
	result := self execute: program.
	self assert: result equals: 3
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileReturnValue [

	| program result |
	program := self compile: '_main ^ 17'.
	result := self execute: program.
	self assert: result equals: 17
]
