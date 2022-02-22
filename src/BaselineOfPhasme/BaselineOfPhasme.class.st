Class {
	#name : #BaselineOfPhasme,
	#superclass : #BaselineOf,
	#category : #BaselineOfPhasme
}

{ #category : #baseline }
BaselineOfPhasme >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec baseline: 'Unicorn' with: [ 
			spec repository: 'github://guillep/pharo-unicorn' ].
		spec baseline: 'LLVMDisassembler' with: [ 
			spec repository: 'github://guillep/pharo-llvmDisassembler' ].
		spec
			package: 'Phasme'
			with: [ spec requires: #( 'Unicorn' 'LLVMDisassembler' ) ] ]
]
