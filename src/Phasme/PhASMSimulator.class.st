Class {
	#name : #PhASMSimulator,
	#superclass : #Object,
	#instVars : [
		'unicorn',
		'code',
		'stack'
	],
	#category : #'Phasme-Simulator'
}

{ #category : #'instance creation' }
PhASMSimulator class >> on: aCompiledProgram [

	^ self new
		initializeOn: aCompiledProgram;
		yourself
]

{ #category : #'as yet unclassified' }
PhASMSimulator >> fakeMainCallerAddress [
	
	"High address"
	^ 16rBADF00D 
]

{ #category : #initialization }
PhASMSimulator >> initializeOn: aCompiledProgram [

	"Now test with unicorn"
	| instructions codeSize initialAddress |
	instructions := aCompiledProgram entryPoint readUpToEnd.
	codeSize := ((instructions size + 4095) / 4096) asInteger * 4096.
	
	"Initialize static memory zone"
	code := ByteArray new: codeSize.
	code replaceFrom: 1
			to: instructions size
			with: instructions
			startingAt: 1.
	
	initialAddress := 16r1000.
	unicorn := Unicorn x8664.
	unicorn
		mapHostMemory: code
		atAddress: initialAddress
		withPermissions: UnicornConstants permissionExecute.
	self rip: initialAddress.

	"Initialize 4K stack zone"
	stack := ByteArray new: 1024 * 4.
	unicorn
		mapHostMemory: stack
		atAddress: 16r80000000
		withPermissions: UnicornConstants permissionRead + UnicornConstants permissionWrite.
	"Put the SP at the end of the stack. Stack grows down!"
	self rsp: 16r80000000 + stack size - 8.
	"Push the main caller address to be able to run until return"
	self push: self fakeMainCallerAddress
]

{ #category : #'stack-management' }
PhASMSimulator >> peek [

	^ unicorn memoryAt: self rsp - 8 readNext: 8
]

{ #category : #'stack-management' }
PhASMSimulator >> pop [
	
	"Stack shrinks up"
	| value |
	value := unicorn memoryAt: self rsp readNext: 8.
	self rsp: self rsp + 8.
	^ value
]

{ #category : #'stack-management' }
PhASMSimulator >> push: anInteger [ 
	
	"Stack grows down"
	| buffer |
	self rsp: self rsp - 8.
	buffer := ByteArray new: 8.
	buffer int64AtOffset: 0 put: anInteger.
	unicorn memoryAt: self rsp write: buffer size: 8.

]

{ #category : #accessing }
PhASMSimulator >> rax [

	^ self readRegister: UcX86Registers rax
]

{ #category : #accessing }
PhASMSimulator >> rbp [

	^ self readRegister: UcX86Registers rbp
]

{ #category : #accessing }
PhASMSimulator >> rbx [

	^ self readRegister: UcX86Registers rbx
]

{ #category : #'as yet unclassified' }
PhASMSimulator >> readRegister: aRegisterId [

	^ (unicorn readRegisterId: aRegisterId value size: 8) uint64AtOffset: 0
]

{ #category : #accessing }
PhASMSimulator >> rip [

	^ self readRegister: UcX86Registers rip
]

{ #category : #'as yet unclassified' }
PhASMSimulator >> rip: aValue [

	^ unicorn
		  register: UcX86Registers rip value
		  write: ((ByteArray new: 8)
				   uint64AtOffset: 0 put: aValue;
				   yourself)
]

{ #category : #accessing }
PhASMSimulator >> rsp [

	^ self readRegister: UcX86Registers rsp
]

{ #category : #'as yet unclassified' }
PhASMSimulator >> rsp: aValue [

	^ unicorn
		  register: UcX86Registers rsp value
		  write: ((ByteArray new: 8)
				   uint64AtOffset: 0 put: aValue;
				   yourself)
]

{ #category : #'as yet unclassified' }
PhASMSimulator >> run [

	^ self runTimeout: 1000
]

{ #category : #'as yet unclassified' }
PhASMSimulator >> runCount: aCount [

	^ unicorn
		  startAt: self rip
		  until: 0
		  timeout: 0
		  count: aCount
]

{ #category : #'as yet unclassified' }
PhASMSimulator >> runTimeout: milliseconds [
	unicorn
		  startAt: self rip
		  until: self fakeMainCallerAddress
		  timeout: milliseconds * 1000
		  count: 0.
	
	"Check we arrived to the caller address. If not, it was probably a timeout"
	self rip = self fakeMainCallerAddress ifTrue: [ ^ self ].
	self error: 'timeout!'
]
