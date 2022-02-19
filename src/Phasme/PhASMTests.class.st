Class {
	#name : #PhASMTests,
	#superclass : #TestCase,
	#category : #'Phasme-Tests'
}

{ #category : #tests }
PhASMTests >> testMove [

	| phasme compiledPhasme simulator |
	phasme := PhASM new build: [ :builder | 
		          builder
			          globalLabel: '_main';
			          move: 'rsp' to: 'rbp' ].
	compiledPhasme := phasme compile.

	simulator := PhASMSimulator on: compiledPhasme.
	simulator rsp: 17.
	simulator runCount: 1.

	self assert: simulator rbp equals: 17
]

{ #category : #tests }
PhASMTests >> testPush [

	| phasme compiledPhasme simulator |
	phasme := PhASM new build: [ :builder | 
		          builder
			          globalLabel: '_main';
			          loadValue: 17 intoRegister: 'rbx';
			          pushRegister: 'rbx';
			          popRegister: 'rax';
			          return ].
	compiledPhasme := phasme compile.

	simulator := PhASMSimulator on: compiledPhasme.
	simulator run.

	self assert: simulator rax equals: 17
]
