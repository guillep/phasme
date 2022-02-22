Class {
	#name : #PhASMExamples,
	#superclass : #Object,
	#category : #'Phasme-Examples'
}

{ #category : #'as yet unclassified' }
PhASMExamples >> callOneArg [

	"Calls 1 arg"

	PhASM new text: [ :builder | 
		| string |
		string := builder string: 'hello world'.
		builder
			globalLabel: '_main';
			push: 'rbp';
			move: 'rsp' to: 'rbp';
			loadReference: string intoRegister: 'rdi';
			call: '_puts';
			pop: 'rbp';
			return ]
]

{ #category : #'as yet unclassified' }
PhASMExamples >> callTwoArgs [

	"Calls 2 args"

	PhASM new text: [ :builder | 
		| string |
		string := builder string: 'hello world? %d'.
		builder
			globalLabel: '_main';
			push: 'rbp';
			move: 'rsp' to: 'rbp';
			loadReference: string intoRegister: 'rdi';
			loadValue: 1 intoRegister: 'rsi';
			call: '_printf';
			pop: 'rbp';
			return ]
]

{ #category : #'as yet unclassified' }
PhASMExamples >> disassembling [

	| phasme compiledPhasme |
	phasme := PhASM new build: [ :builder | 
		          builder
			          globalLabel: '_main';
			          move: 'rsp' to: 'rbp';
			          add: 42 to: 'rax' ].
	compiledPhasme := phasme compile.

	compiledPhasme entryPoint disassemble: 2
	"an OrderedCollection(
	'00000FB1':	movq	%rsp, %rbp
	'00000FB4':	addq	$42, %rax)"
]

{ #category : #'as yet unclassified' }
PhASMExamples >> functions [

	"Defining functions"

	PhASM new text: [ :builder | 
		| string |
		string := builder string: 'hello world? %d'.
		builder
			globalLabel: '_main';
			push: 'rbp';
			move: 'rsp' to: 'rbp';
			loadValue: 56 intoRegister: 'rdi';
			call: 'plus17';
			move: 'rax' to: 'rsi';
			loadReference: string intoRegister: 'rdi';
			call: '_printf';
			pop: 'rbp';
			return;
			label: 'plus17';
			add: 17 to: 'rdi';
			move: 'rdi' to: 'rax';
			return ]
]

{ #category : #'as yet unclassified' }
PhASMExamples >> loop [

	"Loop"

	| header exit |
	PhASM new text: [ :builder | 
		| string |
		string := builder string: 'hello world? %d'.
		builder
			globalLabel: '_main';
			push: 'rbp';
			move: 'rsp' to: 'rbp';
			loadValue: 0 intoRegister: 'rsi'.
		header := builder label: 'loopheader'.
		builder
			compare: 56 to: 'rsi';
			jumpIfEqualsTo: 'exit';
			add: 2 to: 'rsi';
			jumpTo: header.
		exit := builder label: 'exit'.
		builder
			loadReference: string intoRegister: 'rdi';
			call: '_printf';
			pop: 'rbp';
			return ]
]
