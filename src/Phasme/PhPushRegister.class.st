Class {
	#name : #PhPushRegister,
	#superclass : #PhInstruction,
	#instVars : [
		'register'
	],
	#category : #'Phasme-IR'
}

{ #category : #'instance creation' }
PhPushRegister class >> register: aString [ 
	
	^ self new
		register: aString;
		yourself
]

{ #category : #accessing }
PhPushRegister >> register: aString [ 
	register := aString
]

{ #category : #writing }
PhPushRegister >> writeInTextSectionOnStream: aWriteStream [

	aWriteStream
		tab;
		nextPutAll: 'push %';
		nextPutAll: register asString
]
