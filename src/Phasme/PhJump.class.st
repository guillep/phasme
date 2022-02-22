Class {
	#name : #PhJump,
	#superclass : #PhInstruction,
	#instVars : [
		'label'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhJump class >> label: aString [

	^ self new
		  label: aString;
		  yourself
]

{ #category : #'instance creation' }
PhJump class >> name: aString [ 
	
	^ self new name: aString; yourself
]

{ #category : #accessing }
PhJump >> label: aString [ 
	label := aString
]

{ #category : #writing }
PhJump >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'jmp ';
		nextPutAll: label name asString
]
