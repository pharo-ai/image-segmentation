Class {
	#name : #AIImageSegmentator,
	#superclass : #Object,
	#instVars : [
		'originalImage',
		'segmentedImage',
		'segments',
		'clusters',
		'colors',
		'numberOfSegments'
	],
	#category : #'AI-ImageSegmentation'
}

{ #category : #'as yet unclassified' }
AIImageSegmentator class >> defaultColors [

	^ RSColorPalette qualitative set18 range.
]

{ #category : #examples }
AIImageSegmentator class >> example1 [
	<example>
	
	| file segmentator |
	file := self imageDirectory / 'putler.jpeg'.

	segmentator := self new
		loadImage: file;
		numberOfSegments: 2;
		yourself.
	
	segmentator segmentate.
	segmentator openAll.
]

{ #category : #examples }
AIImageSegmentator class >> example2 [
	<example>
	
	| file segmentator |
	file := self imageDirectory / 'stamp.jpg'.

	segmentator := self new
		loadImage: file;
		numberOfSegments: 5;
		yourself.
	
	segmentator segmentate.
	segmentator openAll.
]

{ #category : #origins }
AIImageSegmentator class >> imageDirectory [ 

	^ 'pharo-local/iceberg/pharo-ai/image-segmentation/img' asFileReference
]

{ #category : #colors }
AIImageSegmentator >> blackPixelValue [

	^ self colorAsPixelValue: Color black
]

{ #category : #'as yet unclassified' }
AIImageSegmentator >> buildIndividualSegmentImages [

	| bits |

	^ (1 to: numberOfSegments) collect: [ :i |
    	bits := Bitmap withAll:
			(clusters collect: [ :cluster |
				cluster = i
					ifTrue: [ self blackPixelValue ]
					ifFalse: [ self whitePixelValue ] ]).
				
		self imageFromBits: bits ].
	
]

{ #category : #'as yet unclassified' }
AIImageSegmentator >> buildSegmentedImage [

	| bits |

	bits := Bitmap withAll:
		(clusters collect: [ :cluster |
			self colorAsPixelValue: (colors at: cluster) ]).
		
	^ self imageFromBits: bits
	
]

{ #category : #colors }
AIImageSegmentator >> colorAsPixelValue: aColor [

	^ aColor pixelValueForDepth: originalImage depth
]

{ #category : #accessing }
AIImageSegmentator >> colors: aCollectionOfColors [

	colors := aCollectionOfColors
]

{ #category : #'as yet unclassified' }
AIImageSegmentator >> findPixelClusters [

	| pixelData model |

	pixelData := originalImage bits asOrderedCollection collect: [ :each | { each } ].

	model := AIKMeans numberOfClusters: numberOfSegments.
	model fit: pixelData.
	
	^ model clusters.
]

{ #category : #'as yet unclassified' }
AIImageSegmentator >> imageFromBits: aCollectionOfPixelValues [

	^ Form
		extent: originalImage extent
		depth: originalImage depth
		bits: aCollectionOfPixelValues.
]

{ #category : #initialization }
AIImageSegmentator >> initialize [
	super initialize.
	
	colors := self class defaultColors.
]

{ #category : #accessing }
AIImageSegmentator >> loadImage: aFileReference [

	aFileReference binaryReadStreamDo: [ :stream |
		originalImage := ImageReadWriter formFromStream: stream ].
]

{ #category : #accessing }
AIImageSegmentator >> numberOfSegments: anInteger [

	numberOfSegments := anInteger
]

{ #category : #'as yet unclassified' }
AIImageSegmentator >> openAll [

	AIImagePresenter openImage: originalImage title: 'Original Image'.
	AIImagePresenter openImage: segmentedImage title: 'Segmented Image'.

	segments doWithIndex: [ :segment :i |
		AIImagePresenter openImage: segment title: ('Segment ', i asString) ].
]

{ #category : #'as yet unclassified' }
AIImageSegmentator >> segmentate [

	clusters := self findPixelClusters.
	segmentedImage := self buildSegmentedImage.
	segments := self buildIndividualSegmentImages.
]

{ #category : #colors }
AIImageSegmentator >> whitePixelValue [

	^ self colorAsPixelValue: Color white
]
