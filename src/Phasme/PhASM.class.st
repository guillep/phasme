Class {
	#name : #PhASM,
	#superclass : #Object,
	#category : #'Phasme-Assembler'
}

{ #category : #building }
PhASM >> build: aFullBlockClosure [ 
	
	| builder |
	builder := self newBuilder.
	aFullBlockClosure value: builder.
	^ builder
]

{ #category : #building }
PhASM >> newBuilder [
	
	| builder |
	builder := PhASMTextBuilder new.
	builder phasme: self.
	^ builder
]

{ #category : #exporting }
PhASM >> preambleString [

	^ '# ----------------------------------------------------------------------------------------
# OSX: gcc test.s  && ./a.out
# ----------------------------------------------------------------------------------------'
]

{ #category : #building }
PhASM >> text: aFullBlockClosure [ 
	
	^ self toString: (self build: aFullBlockClosure)
]

{ #category : #exporting }
PhASM >> toString: aPhASMTextBuilder [ 
	
	^ String streamContents: [ :str |
		self writePreambleInStream: str.

		str tab; nextPutAll: '.data'; cr.
		aPhASMTextBuilder instructionsDo: [ :each |
			"It's the instruction responsibility to insert new lines"
			each writeInDataSectionOnStream: str ].

		str tab; nextPutAll: '.text'; cr.
		aPhASMTextBuilder instructionsDo: [ :each |
			each writeInTextSectionOnStream: str.
			str cr ].
	].
]

{ #category : #exporting }
PhASM >> writePreambleInStream: aStream [

	aStream
		nextPutAll: self preambleString;
		cr
]
