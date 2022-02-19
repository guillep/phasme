Class {
	#name : #PhCall,
	#superclass : #PhInstruction,
	#instVars : [
		'label'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhCall class >> label: aString [

	^ self new
		  label: aString;
		  yourself
]

{ #category : #'instance creation' }
PhCall class >> name: aString [ 
	
	^ self new name: aString; yourself
]

{ #category : #accessing }
PhCall >> label: aString [ 
	label := aString
]

{ #category : #writing }
PhCall >> writeInTextSectionOnStream: aWriteStream [ 
	
	aWriteStream
		tab;
		nextPutAll: 'callq ';
		nextPutAll: label asString
]
