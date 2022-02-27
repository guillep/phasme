Class {
	#name : #PhParser,
	#superclass : #Object,
	#instVars : [
		'characterStream',
		'currentToken'
	],
	#category : #'Phasme-Parser'
}

{ #category : #'instance creation' }
PhParser class >> onStream: aReadStream [

	^ self new
		  characterStream: aReadStream;
		  yourself
]

{ #category : #'instance creation' }
PhParser class >> onString: aString [

	^ self onStream: aString readStream
]

{ #category : #'instance creation' }
PhParser class >> parseStream: aReadStream [

	^ (self onStream: aReadStream) parse
]

{ #category : #'instance creation' }
PhParser class >> parseString: aString [ 
	
	^ self parseStream: aString readStream
]

{ #category : #testing }
PhParser >> atEnd [
	
	^ characterStream atEnd
]

{ #category : #accessing }
PhParser >> characterStream: aReadStream [
	
	characterStream := aReadStream
]

{ #category : #scanner }
PhParser >> match: aString [ 
	
	self peekToken = aString
		ifTrue: [ self nextToken ]
		ifFalse: [ self error: 'Expected: ', aString ]
]

{ #category : #scanner }
PhParser >> nextToken [
	
	| separators token |

	"Invalidate peeked token"
	currentToken ifNotNil: [ | returnedToken |
		returnedToken := currentToken.
		currentToken := nil.
		^ returnedToken
	].

	"Skip separators"
	separators := Character separators.
	[separators includes: characterStream peek]
		whileTrue: [ characterStream next ].

	"Special characters are their own token"
	token := ('{}()=' includes: characterStream peek)
		ifTrue: [ characterStream next asString ]
		ifFalse: [ characterStream upToAnyOf: separators ].

	"Skip separators"
	[separators includes: characterStream peek]
		whileTrue: [ characterStream next ].
	^ token
]

{ #category : #parsing }
PhParser >> parse [
	
	"Entry point. Top level accepts function definitions"
	
	| definitions |
	definitions := OrderedCollection new.
	[ self atEnd ] whileFalse: [ 
		definitions add: self parseFunctionDefinition.
	].

	^ PhTopLevelNode new
		definitions: definitions;
		yourself
]

{ #category : #parsing }
PhParser >> parseFunctionDefinition [
	
	"A function definition is of the form
	function <name> [arg list] = { [ statements ] }
	"
	
	| name parameters statements token |
	self match: 'function'.
	name := self nextToken.
	parameters := OrderedCollection new.
	[ (token := self nextToken) = '=' ] whileFalse: [
		parameters add: token
	].
	self match: '{'.
	statements := self parseStatements.
	self match: '}'.

	^ PhFunctionDefinitionNode new
		name: name;
		parameters: parameters;
		statements: statements;
		yourself
]

{ #category : #parsing }
PhParser >> parseLiteral [
	
	| literal number |
	literal := self nextToken.
	number := NumberParser parse: literal.
	^ PhLiteralNode value: number
]

{ #category : #parsing }
PhParser >> parseStatement [
	
	^ self parseLiteral
]

{ #category : #parsing }
PhParser >> parseStatements [
	
	| statements |
	statements := OrderedCollection new.
	[self peekToken = '}'] whileFalse: [
		statements add: self parseStatement ].
	^ statements
]

{ #category : #scanner }
PhParser >> peekToken [

	currentToken ifNotNil: [ ^ currentToken ].
	^ currentToken := self nextToken
]
