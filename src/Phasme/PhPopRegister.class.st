Class {
	#name : #PhPopRegister,
	#superclass : #PhInstruction,
	#instVars : [
		'register'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhPopRegister class >> register: aString [ 
	
	^ self new
		register: aString;
		yourself
]

{ #category : #accessing }
PhPopRegister >> register: aString [ 
	register := aString
]

{ #category : #writing }
PhPopRegister >> writeInTextSectionOnStream: aWriteStream [

	aWriteStream
		tab;
		nextPutAll: 'pop %';
		nextPutAll: register asString
]
