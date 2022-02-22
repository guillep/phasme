Class {
	#name : #PhASMTextBuilder,
	#superclass : #Object,
	#instVars : [
		'instructions',
		'phasme',
		'labelCount'
	],
	#category : #'Phasme-Assembler'
}

{ #category : #building }
PhASMTextBuilder >> addRegister: operand to: aString [ 
	
	^ instructions add: (PhAddRegister operand: operand destination: aString)
]

{ #category : #building }
PhASMTextBuilder >> addValue: anInteger to: aString [ 
	
	^ instructions add: (PhAddValue value: anInteger destination: aString)
]

{ #category : #building }
PhASMTextBuilder >> call: aString [ 
	
	instructions add: (PhCall label: aString)
]

{ #category : #building }
PhASMTextBuilder >> compare: aLiteral to: aRegister [
	
	instructions add: (PhCompare value: aLiteral destination: aRegister)
]

{ #category : #building }
PhASMTextBuilder >> compareRegister: register1 toRegister: register2 [
	
	instructions add: (PhCompareRegisters register1: register1 register2: register2)
]

{ #category : #compiling }
PhASMTextBuilder >> compile [
	
	| asmFile error |
	asmFile := FileLocator temp / 'tmp.s'.
	asmFile ensureDelete; writeStreamDo: [ :str |
		str nextPutAll: self toString ].

	error := LibC system: ('gcc -s {1}' format: { asmFile fullName }).
	error ~= 0 ifTrue: [ self error: 'could not compile, check you have gcc and your asm syntax!' ].
	
	^ PhMachOFile reference: FileSystem workingDirectory / 'a.out'
]

{ #category : #building }
PhASMTextBuilder >> globalLabel: aString [
	
	^ (self label: aString) beGlobal
]

{ #category : #building }
PhASMTextBuilder >> initialize [
	super initialize.
	instructions := OrderedCollection new.
	labelCount := 0.
]

{ #category : #enumerating }
PhASMTextBuilder >> instructionsDo: aFullBlockClosure [ 
	
	instructions do: aFullBlockClosure
]

{ #category : #building }
PhASMTextBuilder >> jump [

	^ instructions add: PhJump new
]

{ #category : #building }
PhASMTextBuilder >> jumpIfEquals [
	
	^ instructions add: (PhJumpIfEquals new)
]

{ #category : #building }
PhASMTextBuilder >> jumpIfEqualsTo: aString [ 
	
	instructions add: (PhJumpIfEquals label: aString)
]

{ #category : #building }
PhASMTextBuilder >> jumpTo: aString [ 
	
	instructions add: (PhJump label: aString)
]

{ #category : #building }
PhASMTextBuilder >> label: aString [

	^ instructions add: (PhLabel name: aString)
]

{ #category : #building }
PhASMTextBuilder >> loadReference: aReference intoRegister: aString [ 
	
	instructions add: (PhLoadReference reference: aReference intoRegister: aString)
]

{ #category : #building }
PhASMTextBuilder >> loadRegister: base offset: offset intoRegister: destination [ 
	
	instructions add: (PhLoadRegisterOffset new
		base: base;
		offset: offset;
		destination: destination;
		yourself)
]

{ #category : #building }
PhASMTextBuilder >> loadValue: aLiteral intoRegister: aRegister [
	
	instructions add: (PhLoadValue value: aLiteral intoRegister: aRegister)
]

{ #category : #building }
PhASMTextBuilder >> move: origin to: destination [ 
	
	instructions add: (PhMove from: origin to: destination)
]

{ #category : #building }
PhASMTextBuilder >> multiplyRegister: operand to: aString [ 
	
	^ instructions add: (PhMultiplyRegister source: operand destination: aString)
]

{ #category : #building }
PhASMTextBuilder >> newLabel [

	^ self label: 'L' , (labelCount := labelCount + 1) asString
]

{ #category : #accessing }
PhASMTextBuilder >> phasme: aPhASM [

	phasme := aPhASM
]

{ #category : #building }
PhASMTextBuilder >> popRegister: aString [ 
	
	instructions add: (PhPopRegister register: aString)
]

{ #category : #instructions }
PhASMTextBuilder >> pushRegister: aString [ 

	instructions add: (PhPushRegister register: aString)
]

{ #category : #instructions }
PhASMTextBuilder >> pushValue: aNumber [ 

	"Only support integers for now!"
	instructions add: (PhPushValue value: aNumber)
]

{ #category : #building }
PhASMTextBuilder >> return [
	
	instructions add: PhReturn new
]

{ #category : #building }
PhASMTextBuilder >> setEqualsConditionCodeToRegister: register [
	
	instructions add: (PhSetEqualsConditionCode new destination: register; yourself)
]

{ #category : #building }
PhASMTextBuilder >> storeRegister: aRegister intoRegister: aString offset: offset [
	
	instructions add: (PhStoreRegisterToRegisterOffset new
		source: aRegister;
		base: aString;
		offset: offset;
		yourself)
]

{ #category : #building }
PhASMTextBuilder >> string: aString [

	| string |
	string := PhString id: instructions size value: aString.
	instructions add: string.
	^ string
]

{ #category : #building }
PhASMTextBuilder >> subtractRegister: operand to: aString [ 
	
	^ instructions add: (PhSubtractRegister source: operand destination: aString)
]

{ #category : #building }
PhASMTextBuilder >> subtractValue: anInteger to: aString [ 
	
	^ instructions add: (PhSubtractValue value: anInteger destination: aString)
]

{ #category : #encoing }
PhASMTextBuilder >> toString [
	
	^ phasme toString: self
]
