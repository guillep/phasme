Class {
	#name : #PhMachOLoadCommand,
	#superclass : #Object,
	#instVars : [
		'file',
		'offset'
	],
	#category : #'Phasme-Loader'
}

{ #category : #converting }
PhMachOLoadCommand >> asEntryPoint [
	
	^ PhMachOEntryPointLoadCommand new
		file: file;
		offset: offset;
		yourself
]

{ #category : #accessing }
PhMachOLoadCommand >> data [
	
	^ file read: self size - 8 "header size" at: offset
]

{ #category : #'as yet unclassified' }
PhMachOLoadCommand >> fields [

	^ { 
		  ('Load Command (cmd)' -> self loadCommand).
		  ('Size of Load Command (cmdsize)' -> self loadCommandSize) }
]

{ #category : #accessing }
PhMachOLoadCommand >> file [

	^ file
]

{ #category : #accessing }
PhMachOLoadCommand >> file: anObject [

	file := anObject
]

{ #category : #'as yet unclassified' }
PhMachOLoadCommand >> inspectLoaderCommandIn: aBuilder [

	<inspectorPresentationOrder: 30 title: 'Loader Command Structure'>
	^ aBuilder newTable
		  addColumn: (SpStringTableColumn
				   title: #key
				   evaluated: [ :anAssociation | anAssociation key ]);
		  addColumn: (SpStringTableColumn
				   title: #value
				   evaluated: [ :anAssociation | anAssociation value ]);
		  items: self fields;
		  yourself
]

{ #category : #testing }
PhMachOLoadCommand >> isMain [
	
	"LC_MAIN. See https://github.com/gdbinit/MachOView/blob/master/mach-o/loader.h"
	^ self loadCommand = (16r80000000 + 16r28)
]

{ #category : #accessing }
PhMachOLoadCommand >> loadCommand [
	
	^ file uint32AtOffset: offset
]

{ #category : #accessing }
PhMachOLoadCommand >> loadCommandSize [
	
	^ file uint32AtOffset: offset + 4
]

{ #category : #accessing }
PhMachOLoadCommand >> offset [

	^ offset
]

{ #category : #accessing }
PhMachOLoadCommand >> offset: anObject [

	offset := anObject
]

{ #category : #accessing }
PhMachOLoadCommand >> size [

	^ self loadCommandSize
]
