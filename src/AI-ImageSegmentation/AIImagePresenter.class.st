Class {
	#name : #AIImagePresenter,
	#superclass : #SpMorphPresenter,
	#instVars : [
		'title'
	],
	#category : #'AI-ImageSegmentation'
}

{ #category : #accessing }
AIImagePresenter class >> defaultExtent [

	^ 100@100
]

{ #category : #specs }
AIImagePresenter class >> defaultSpec [

	
]

{ #category : #accessing }
AIImagePresenter class >> defaultTitle [

	^ 'Image'
]

{ #category : #'as yet unclassified' }
AIImagePresenter class >> openImage: aForm [

	^ self new
		image: aForm;
		open
]

{ #category : #'as yet unclassified' }
AIImagePresenter class >> openImage: aForm title: aString [

	^ self new
		image: aForm;
		title: aString;
		open
]

{ #category : #accessing }
AIImagePresenter >> extent [

	^ extent ifNil: [ self class defaultExtent ].
]

{ #category : #accessing }
AIImagePresenter >> image: aForm [

	self morph: aForm asMorph.
	self extent: aForm extent.
]

{ #category : #initialization }
AIImagePresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self title;
		initialExtent: self extent.
]

{ #category : #accessing }
AIImagePresenter >> title [

	^ title ifNil: [ self class defaultTitle ].
]

{ #category : #accessing }
AIImagePresenter >> title: aString [

	title := aString
]
