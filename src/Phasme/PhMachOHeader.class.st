Class {
	#name : #PhMachOHeader,
	#superclass : #Object,
	#instVars : [
		'file'
	],
	#category : #'Phasme-Loader'
}

{ #category : #'instance creation' }
PhMachOHeader class >> file: aPhMachOFile [
	
	^ self new
		file: aPhMachOFile;
		yourself
]

{ #category : #accessing }
PhMachOHeader >> cpuSubType [
	
	^ file int32AtOffset: 8
]

{ #category : #accessing }
PhMachOHeader >> cpuSubTypeDescriptor [
	
	^ self cpuSubType hex
]

{ #category : #accessing }
PhMachOHeader >> cpuType [
	
	^ file uint32AtOffset: 4
]

{ #category : #accessing }
PhMachOHeader >> cpuTypeDescriptor [
	
	| cpuType |
	cpuType := self cpuType.
	cpuType = 7
		ifTrue: [ ^ 'x86 (7)' ].
	cpuType = (16r01000000 + 7)
		ifTrue: [ ^ 'x86-64 (16r01000007)' ].
	cpuType = (16r01000000 + 12)
		ifTrue: [ ^ 'x86-64 (16r0100000C)' ].

	self error: 'Unsupported CPU Type: ', cpuType asString
]

{ #category : #accessing }
PhMachOHeader >> file: aPhMachOFile [ 
	file := aPhMachOFile
]

{ #category : #accessing }
PhMachOHeader >> fileType [
	
	^ file int32AtOffset: 12
]

{ #category : #accessing }
PhMachOHeader >> flags [

	^ file int32AtOffset: 24
]

{ #category : #'as yet unclassified' }
PhMachOHeader >> inspectHeaderIn: aBuilder [

	<inspectorPresentationOrder: 30 title: 'Header Structure'>
	| items |
	items := { 
		         ('magic' -> self magicDescriptor).
		         ('cpu type' -> self cpuTypeDescriptor).
		         ('cpu subtype' -> self cpuSubType).
		         ('file type' -> self fileType).
		         ('Number of Load Commands (ncmds)'
		          -> self numberOfLoadComands).
		         ('Size of Load Commands Region(sizeofcmds)'
		          -> self sizeOfLoadCommandsRegion).
		         ('flags' -> self flags).
		         ('reserved' -> self reserved) }.
	^ aBuilder newTable
		  addColumn: (SpStringTableColumn
				   title: #key
				   evaluated: [ :anAssociation | anAssociation key ]);
		  addColumn: (SpStringTableColumn
				   title: #value
				   evaluated: [ :anAssociation | anAssociation value ]);
		  items: items;
		  yourself
]

{ #category : #accessing }
PhMachOHeader >> magic [
	
	^ file uint32AtOffset: 0
]

{ #category : #accessing }
PhMachOHeader >> magicDescriptor [
	
	| magic |
	magic := self magic.
	magic = 16rfeedface
		ifTrue: [ ^ '32 bits (16rfeedface)' ].
	magic = 16rfeedfacf
		ifTrue: [ ^ '64 bits (16rfeedfacf)' ].
	magic = 16rcafebabe
		ifTrue: [ ^ 'Universal (16rcafebabe)' ].
	self error: 'Unrecognized magic'
]

{ #category : #accessing }
PhMachOHeader >> numberOfLoadComands [
	
	^ file int32AtOffset: 16
]

{ #category : #accessing }
PhMachOHeader >> reserved [

	^ file int32AtOffset: 28
]

{ #category : #accessing }
PhMachOHeader >> sizeOfLoadCommandsRegion [
	
	^ file int32AtOffset: 20
]
