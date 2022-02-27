Class {
	#name : #PhParserTest,
	#superclass : #TestCase,
	#category : #'Phasme-Tests'
}

{ #category : #accessing }
PhParserTest class >> value: aValue [

	^ self new
		value: aValue;
		yourself
]

{ #category : #helpers }
PhParserTest >> parse: aString [ 
	
	^ PhParser parseString: aString
]

{ #category : #tests }
PhParserTest >> testParseFunction [

	| ast function |
	ast := self parse: 'function main = { }'.
	function := ast definitions first.
	
	self assert: function name equals: 'main'
]

{ #category : #tests }
PhParserTest >> testParseFunctionWithNonSeparatedBraces [

	| ast function |
	ast := self parse: 'function main = {}'.
	function := ast definitions first.
	
	self assert: function name equals: 'main'
]

{ #category : #tests }
PhParserTest >> testParseFunctions [

	| ast |
	ast := self parse: 'function main = { } function factorial = {}'.
	
	self assert: ast definitions first name equals: 'main'.
	self assert: ast definitions second name equals: 'factorial'
]

{ #category : #tests }
PhParserTest >> testParseNumbers [

	| parser |
	parser := PhParser onString: '1 2 3'.
	
	self assert: parser nextToken equals: '1'.
	self assert: parser nextToken equals: '2'.
	self assert: parser nextToken equals: '3'.
]

{ #category : #tests }
PhParserTest >> testParseStatements [

	| ast function |
	ast := self parse: 'function main = { 1 }'.
	function := ast definitions first.
	
	self assert: function statements first equals: (PhLiteralNode value: 1)
]
