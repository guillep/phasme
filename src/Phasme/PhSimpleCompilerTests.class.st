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
PhSimpleCompilerTests >> compileFunctions: aCollection [

	| compiler |
	compiler := PhPharoCompiler new.
	aCollection do: [ :each | compiler addMethod: each ].
	^ compiler compile
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
PhSimpleCompilerTests >> testCompileConditional [

	| program result |
	program := self compileFunctions: {
		'_main ^ self factorial: 5'.
		'factorial: arg
			arg = 0
				ifTrue: [ ^ 1 ]
				ifFalse: [ ^ arg * (self factorial: arg - 1) ]'
		}.
	result := self execute: program.
	self assert: result equals: 120
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileEqualsFalse [

	| program result |
	program := self compile: '_main ^ 1 = 7'.
	result := self execute: program.
	self assert: result equals: 0
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileEqualsFalseWithFullRAX [

	| program result |
	program := self compileFunctions: {
		'_main
			"returnLargeNumber should put a number larger than a byte in RAX"
			self returnLargeNumber.
			self call'.
		'returnLargeNumber ^ 512'.
		'call ^ 1 = 2'
		}.
	result := self execute: program.
	self assert: result equals: 0
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileEqualsTrue [

	| program result |
	program := self compile: '_main ^ 2 = 2'.
	result := self execute: program.
	self assert: result equals: 1
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileEqualsTrueWithFullRAX [

	| program result |
	program := self compileFunctions: {
		'_main
			"returnLargeNumber should put a number larger than a byte in RAX"
			self returnLargeNumber.
			self call'.
		'returnLargeNumber ^ 512'.
		'call ^ 2 = 2'
		}.
	result := self execute: program.
	self assert: result equals: 1
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileFunctionCall [

	| program result |
	program := self compileFunctions: {
		'_main ^ self call'.
		'call ^ 1 + 2'
		}.
	result := self execute: program.
	self assert: result equals: 3
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileFunctionCallWithArguments [

	| program result |
	program := self compileFunctions: {
		'_main ^ self call: 17'.
		'call: param ^ param + 2'
		}.
	result := self execute: program.
	self assert: result equals: 19
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
PhSimpleCompilerTests >> testCompileMultiply [

	| program result |
	program := self compile: '_main ^ 2 * 3'.
	result := self execute: program.
	self assert: result equals: 6
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileReturnValue [

	| program result |
	program := self compile: '_main ^ 17'.
	result := self execute: program.
	self assert: result equals: 17
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileSubtract [

	| program result |
	program := self compile: '_main ^ 2 - 1'.
	result := self execute: program.
	self assert: result equals: 1
]

{ #category : #tests }
PhSimpleCompilerTests >> testCompileSum [

	| program result |
	program := self compile: '_main ^ 1 + 2'.
	result := self execute: program.
	self assert: result equals: 3
]
