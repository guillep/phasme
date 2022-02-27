Class {
	#name : #PhPharoStackCompilerTest,
	#superclass : #TestCase,
	#category : #'Phasme-Tests'
}

{ #category : #tests }
PhPharoStackCompilerTest >> compile: pharoMethodSource [

	^ PhPharoCompiler compileMethod: pharoMethodSource.
	
]

{ #category : #tests }
PhPharoStackCompilerTest >> compileFunctions: aCollection [

	| compiler |
	compiler := PhPharoCompiler new.
	aCollection do: [ :each | compiler addMethod: each ].
	^ compiler compile
]

{ #category : #tests }
PhPharoStackCompilerTest >> execute: compiledPhasme [
	
	| simulator |
	simulator := PhASMSimulator on: compiledPhasme.
	simulator run.

	"Return value"
	^ simulator rax
]

{ #category : #tests }
PhPharoStackCompilerTest >> testCompileConditional [

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
PhPharoStackCompilerTest >> testCompileEqualsFalse [

	| program result |
	program := self compile: '_main ^ 1 = 7'.
	result := self execute: program.
	self assert: result equals: 0
]

{ #category : #tests }
PhPharoStackCompilerTest >> testCompileEqualsFalseWithFullRAX [

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
PhPharoStackCompilerTest >> testCompileEqualsTrue [

	| program result |
	program := self compile: '_main ^ 2 = 2'.
	result := self execute: program.
	self assert: result equals: 1
]

{ #category : #tests }
PhPharoStackCompilerTest >> testCompileEqualsTrueWithFullRAX [

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
PhPharoStackCompilerTest >> testCompileFunctionCall [

	| program result |
	program := self compileFunctions: {
		'_main ^ self call'.
		'call ^ 1 + 2'
		}.
	result := self execute: program.
	self assert: result equals: 3
]

{ #category : #tests }
PhPharoStackCompilerTest >> testCompileFunctionCallWithArguments [

	| program result |
	program := self compileFunctions: {
		'_main ^ self call: 17'.
		'call: param ^ param + 2'
		}.
	result := self execute: program.
	self assert: result equals: 19
]

{ #category : #tests }
PhPharoStackCompilerTest >> testCompileImplicitReturn [

	| program result |
	program := self compile: '_main'.
	result := self execute: program.
	self assert: result equals: 0
]

{ #category : #tests }
PhPharoStackCompilerTest >> testCompileLocalVariables [

	| program result |
	program := self compile: '_main | a | 
		a := 2.
		^ 1 + a'.
	result := self execute: program.
	self assert: result equals: 3
]

{ #category : #tests }
PhPharoStackCompilerTest >> testCompileMultiply [

	| program result |
	program := self compile: '_main ^ 2 * 3'.
	result := self execute: program.
	self assert: result equals: 6
]

{ #category : #tests }
PhPharoStackCompilerTest >> testCompileReturnValue [

	| program result |
	program := self compile: '_main ^ 17'.
	result := self execute: program.
	self assert: result equals: 17
]

{ #category : #tests }
PhPharoStackCompilerTest >> testCompileSubtract [

	| program result |
	program := self compile: '_main ^ 2 - 1'.
	result := self execute: program.
	self assert: result equals: 1
]

{ #category : #tests }
PhPharoStackCompilerTest >> testCompileSum [

	| program result |
	program := self compile: '_main ^ 1 + 2'.
	result := self execute: program.
	self assert: result equals: 3
]
