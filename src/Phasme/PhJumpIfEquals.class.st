Class {
	#name : #PhJumpIfEquals,
	#superclass : #PhInstruction,
	#instVars : [
		'label'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhJumpIfEquals class >> label: aString [

	^ self new
		  label: aString;
		  yourself
]

{ #category : #'instance creation' }
PhJumpIfEquals class >> name: aString [ 
	
	^ self new name: aString; yourself
]

{ #category : #accessing }
PhJumpIfEquals >> label: aString [ 
	label := aString
]

{ #category : #writing }
PhJumpIfEquals >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'je ';
		nextPutAll: label name asString
]
