Class {
	#name : #PhMachOFile,
	#superclass : #Object,
	#instVars : [
		'reference'
	],
	#category : #'Phasme-Loader'
}

{ #category : #accessing }
PhMachOFile class >> reference: aFileReference [

	^ self new
		reference: aFileReference;
		yourself
]

{ #category : #accessing }
PhMachOFile >> binaryReadStream [
	
	^ reference binaryReadStream
]

{ #category : #accessing }
PhMachOFile >> entryPoint [
	
	^ (self loadCommands detect: [ :command | command isMain ]) asEntryPoint
]

{ #category : #accessing }
PhMachOFile >> header [
	
	^ PhMachOHeader file: self
]

{ #category : #reading }
PhMachOFile >> int32AtOffset: anInteger [

	^ (reference binaryReadStream
		   skip: anInteger;
		   next: 4) int32AtOffset: 0
]

{ #category : #accessing }
PhMachOFile >> loadCommandAt: anInteger [ 
	
	^ PhMachOLoadCommand new
		file: self;
		offset: anInteger;
		yourself
]

{ #category : #accessing }
PhMachOFile >> loadCommands [

	| offset |
	offset := 32. "Skip the header"
	^ (1 to: self header numberOfLoadComands) collect: [ :i | | command |
		command := self loadCommandAt: offset.
		offset := offset + command size.
		command ]
]

{ #category : #reading }
PhMachOFile >> read: bytes at: offset [
	
	^ (reference binaryReadStream skip: offset) next: bytes
]

{ #category : #accessing }
PhMachOFile >> reference [

	^ reference
]

{ #category : #accessing }
PhMachOFile >> reference: anObject [

	reference := anObject
]

{ #category : #reading }
PhMachOFile >> uint32AtOffset: anInteger [

	^ (reference binaryReadStream
		   skip: anInteger;
		   next: 4) uint32AtOffset: 0
]

{ #category : #reading }
PhMachOFile >> uint64AtOffset: anInteger [

	^ (reference binaryReadStream
		   skip: anInteger;
		   next: 8) uint64AtOffset: 0
]
