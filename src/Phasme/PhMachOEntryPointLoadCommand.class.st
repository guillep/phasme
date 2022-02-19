Class {
	#name : #PhMachOEntryPointLoadCommand,
	#superclass : #PhMachOLoadCommand,
	#category : #'Phasme-Loader'
}

{ #category : #disassembling }
PhMachOEntryPointLoadCommand >> disassemble: anInteger [

	| bytes |
	bytes := file read: anInteger * 10 at: self entryOffset. "bytes per instruction?"
	^ LLVMDisassembler amd64
		disassembleNext: anInteger
		instructionsIn: bytes
		startAddress: self entryOffset
		pc: self entryOffset
]

{ #category : #accessing }
PhMachOEntryPointLoadCommand >> entryOffset [
	
	^ file uint64AtOffset: offset + 8 "base offset"
]

{ #category : #'field definition' }
PhMachOEntryPointLoadCommand >> fields [

	^ super fields , { 
		  ('Entry offset (entryoff)' -> self entryOffset).
		  ('Stack size (stacksize)' -> self stackSize) }
]

{ #category : #reading }
PhMachOEntryPointLoadCommand >> readUpToEnd [
	
	^ (file binaryReadStream skip: self entryOffset) upToEnd
]

{ #category : #accessing }
PhMachOEntryPointLoadCommand >> stackSize [
	
	^ file uint64AtOffset: offset + 16
]
