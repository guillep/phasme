Class {
	#name : #PhPharoCompiler,
	#superclass : #Object,
	#instVars : [
		'methods',
		'phasme',
		'builder',
		'localPositions',
		'nextStackPosition'
	],
	#category : #'Phasme-Compiler'
}

{ #category : #compiling }
PhPharoCompiler class >> compileMethod: aString [ 
	
	^ self new
		addMethod: aString;
		compile
]

{ #category : #building }
PhPharoCompiler >> addMethod: aString [ 
	
	methods add: (RBParser parseMethod: aString)
]

{ #category : #compiling }
PhPharoCompiler >> compile [
	
	methods do: [ :e | e acceptVisitor: self ].
	^ builder compile
]

{ #category : #compiling }
PhPharoCompiler >> compileAdd: addNode [

	self
		compileBinaryOperator: addNode
		doing: [ :r1 :r2 |
			builder addRegister: r1 to: r2 ]
]

{ #category : #compiling }
PhPharoCompiler >> compileBinaryOperator: aNode doing: aBlock [
	
	"Compile operands, they will push the values to the stack"
	aNode receiver acceptVisitor: self.
	aNode arguments first acceptVisitor: self.
	
	"Put the second operand in rbx"
	builder popRegister: 'rbx'.
	"Put the first operand in rax"
	builder popRegister: 'rax'.
	
	aBlock value: 'rbx' value: 'rax'.
	
	"Push the result to the stack"
	builder pushRegister: 'rax'
]

{ #category : #compiling }
PhPharoCompiler >> compileConditional: aConditional [ 
	
	"Compile this way.
		condition
		jumpiffalse falselabel
	truelabel:	
		code for true
		jump end
	falselabel:
		code for false
	end:
		following instructions...
	"
	
	"Condition should push a 0 if flase or 1 if true"
	| ifEquals jumpEnd |
	aConditional receiver acceptVisitor: self.
	builder popRegister: 'rax'.
	builder compare: 0 to: 'rax'.
	ifEquals := builder jumpIfEquals.
	aConditional arguments first acceptVisitor: self.
	jumpEnd := builder jump.
	ifEquals label: builder newLabel.
	aConditional arguments second acceptVisitor: self.
	jumpEnd label: builder newLabel
]

{ #category : #compiling }
PhPharoCompiler >> compileEquals: equalsNode [
	
	self
		compileBinaryOperator: equalsNode
		doing: [ :r1 :r2 |
			"Compare and set the value of the equals flag to rax"
			builder compareRegister: r1 toRegister: r2.
			builder setEqualsConditionCodeToRegister: r2 ]
]

{ #category : #compiling }
PhPharoCompiler >> compileFunctionCall: aFunctionCall [
	
	"This is a function call like
		self foo: 17.
	Ignore the receiver self, and compile it like foo(17)"
	aFunctionCall arguments size > 1 ifTrue: [ self error: 'not supported yet' ].
	
	aFunctionCall arguments do: [ :arg | arg acceptVisitor: self ].
	
	"Calling convention. First argument goes in RDI, second in RSI"
	aFunctionCall arguments size > 1
		ifTrue: [ builder popRegister: 'rsi' ].
	aFunctionCall arguments size > 0
		ifTrue: [ builder popRegister: 'rdi' ].
	builder call: (self mangleSelector: aFunctionCall selector).
	builder pushRegister: 'rax'.
]

{ #category : #compiling }
PhPharoCompiler >> compileMultiply: multiplyNode [
	
	self
		compileBinaryOperator: multiplyNode
		doing: [ :r1 :r2 |
			builder multiplyRegister: r1 to: r2 ]
]

{ #category : #compiling }
PhPharoCompiler >> compileSubtract: subtractNode [
	
	self
		compileBinaryOperator: subtractNode
		doing: [ :r1 :r2 |
			builder subtractRegister: r1 to: r2 ]
]

{ #category : #initialization }
PhPharoCompiler >> initialize [
	super initialize.
	
	methods := OrderedCollection new.
	phasme := PhASM new.
	builder := phasme newBuilder.
	
	localPositions := Dictionary new.
	nextStackPosition := 0
]

{ #category : #visiting }
PhPharoCompiler >> mangleSelector: aSelector [
	"ASM does not like to have colons. Replace them with dashes (-) and escape dashes"
	
	| escaped |
	escaped := aSelector copyReplaceAll: 'arbitrario' with: 'arbitrarioarbitrario'.
	^ escaped copyReplaceAll: ':' with: 'arbitrario'
]

{ #category : #initialization }
PhPharoCompiler >> nextStackPosition [
	
	| allocatedStackPosition |
	allocatedStackPosition := nextStackPosition.
	nextStackPosition := nextStackPosition + 8.
	^ allocatedStackPosition
]

{ #category : #names }
PhPharoCompiler >> reserveStackPositionFor: aRBVariableNode [ 
	
	localPositions at: aRBVariableNode name put: self nextStackPosition
]

{ #category : #visiting }
PhPharoCompiler >> return [

	"Destroying the current sp will deallocate the local variables automatically"
	builder move: 'rbp' to: 'rsp'.
	builder popRegister: 'rbp'.
	builder return
]

{ #category : #visiting }
PhPharoCompiler >> visitAssignmentNode: aRBAssignmentNode [ 
	
	aRBAssignmentNode value acceptVisitor: self.
	builder popRegister: 'rax'.
	builder storeRegister: 'rax' intoRegister: 'rbp' offset: (localPositions at: aRBAssignmentNode variable name)
]

{ #category : #visiting }
PhPharoCompiler >> visitBlockNode: aRBBlockNode [ 
	
	aRBBlockNode statements do: [ :e | e acceptVisitor: self ].
]

{ #category : #visiting }
PhPharoCompiler >> visitLiteralValueNode: aRBLiteralValueNode [ 
	
	builder pushValue: aRBLiteralValueNode value
]

{ #category : #visiting }
PhPharoCompiler >> visitMessageNode: aRBMessageNode [ 
	
	"We only know how to compile a sum for now"
	aRBMessageNode selector = #+
		ifTrue: [ ^ self compileAdd: aRBMessageNode ].
	aRBMessageNode selector = #-
		ifTrue: [ ^ self compileSubtract: aRBMessageNode ].
	aRBMessageNode selector = #*
		ifTrue: [ ^ self compileMultiply: aRBMessageNode ].
	
	aRBMessageNode selector = #=
		ifTrue: [ ^ self compileEquals: aRBMessageNode ].
	aRBMessageNode selector = #ifTrue:ifFalse:
		ifTrue: [ ^ self compileConditional: aRBMessageNode ].

	self compileFunctionCall: aRBMessageNode
	
	
]

{ #category : #visiting }
PhPharoCompiler >> visitMethodNode: aRBMethodNode [ 
	
	builder globalLabel: (self mangleSelector: aRBMethodNode selector).
	aRBMethodNode temporaries do: [ :e |
		self reserveStackPositionFor: e.
	].

	"Create the new frame: store the caller's bp, then set ours with the value of sp"
	builder pushRegister: 'rbp'.
	builder move: 'rsp' to: 'rbp'.
	"Now allocate the local variables space!
	They will be deallocated upon return"
	builder addValue: nextStackPosition negated to: 'rsp'.
	aRBMethodNode statements do: [ :e | e acceptVisitor: self ].
	
	"All methods have a return statement at the end.
	We add a return statement here just in case.
	In the worst case scenario, we are creating a return instruction followed by another one, and the second one is unreachable"
	self return
]

{ #category : #visiting }
PhPharoCompiler >> visitReturnNode: aRBReturnNode [ 
	
	aRBReturnNode value acceptVisitor: self.
	
	"Pop the result of the expression into the rax register representing the result, then return"
	builder popRegister: 'rax'.
	self return
]

{ #category : #visiting }
PhPharoCompiler >> visitVariableNode: aRBVariableNode [
	
	"Calling convention:
		1st param: RDI
		2nd param: RSI
	"
	| parameterIndex |
	parameterIndex := aRBVariableNode methodNode arguments indexOf: aRBVariableNode.
	parameterIndex > 0 "is parameter?" ifTrue: [
		parameterIndex = 1 ifTrue: [ ^ builder pushRegister: 'rdi' ].
		parameterIndex = 2 ifTrue: [ ^ builder pushRegister: 'rsi' ].
		self error: 'Unsupported number of parameters'
	].
	
	builder loadRegister: 'rbp' offset: (localPositions at: aRBVariableNode name) intoRegister: 'rax'.
	builder pushRegister: 'rax'
]
