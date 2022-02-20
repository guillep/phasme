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

{ #category : #visiting }
PhPharoCompiler >> compileAdd: addNode [
	
	addNode receiver acceptVisitor: self.
	addNode arguments first acceptVisitor: self.
	
	"Put the second operand in rbx"
	builder popRegister: 'rbx'.
	"Put the first operand in rax"
	builder popRegister: 'rax'.
	"add them up!"
	builder addRegister: 'rbx' to: 'rax'.
	
	"Push the result to the stack"
	builder pushRegister: 'rax'
]

{ #category : #visiting }
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
PhPharoCompiler >> visitLiteralValueNode: aRBLiteralValueNode [ 
	
	builder pushValue: aRBLiteralValueNode value
]

{ #category : #visiting }
PhPharoCompiler >> visitMessageNode: aRBMessageNode [ 
	
	"We only know how to compile a sum for now"
	aRBMessageNode selector = #+
		ifTrue: [ ^ self compileAdd: aRBMessageNode ].

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
