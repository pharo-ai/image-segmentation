Class {
	#name : #AIImageSegmentator,
	#superclass : #Object,
	#instVars : [
		'originalImage',
		'segmentedImage',
		'segments',
		'numberOfSegments',
		'clusteringModel',
		'whiteOnBlackSegments'
	],
	#category : #'AI-ImageSegmentation'
}

{ #category : #examples }
AIImageSegmentator class >> example1 [
	<example>
	
	| file segmentator |
	file := self imageDirectory / 'arid_mountain.jpg'.

	segmentator := self new
		loadImage: file;
		numberOfSegments: 2;
		yourself.
	
	segmentator clusterImagePixels.
	segmentator segmentate.
	segmentator openAll.
]

{ #category : #examples }
AIImageSegmentator class >> example2 [
	<example>
	
	| file segmentator |
	file := self imageDirectory / 'renoir_river.jpg'.

	segmentator := self new
		loadImage: file;
		numberOfSegments: 3;
		yourself.
	
	segmentator clusterImagePixels.
	segmentator segmentate.
	segmentator openAll.
]

{ #category : #origins }
AIImageSegmentator class >> imageDirectory [ 

	^ 'pharo-local/iceberg/pharo-ai/image-segmentation/img' asFileReference
]

{ #category : #default }
AIImageSegmentator class >> openImagePresenter: image title: title [

	| imagePresenter window |
	imagePresenter := SpImagePresenter new.
	imagePresenter image: image.
	window := imagePresenter open.
	window
		extent: self windowExtent;
		title: title.
		
	^ imagePresenter
	
]

{ #category : #default }
AIImageSegmentator class >> windowExtent [

	^ 1000 @ 1000
]

{ #category : #segmentation }
AIImageSegmentator >> buildIndividualSegmentImages [

	| bits |

	^ (1 to: numberOfSegments) collect: [ :i |
    	bits := Bitmap withAll:
			(self clusters collect: [ :cluster |
				cluster = i
					ifTrue: [ self colorAsPixelValue: (self segmentFillColor: i) ]
					ifFalse: [ self colorAsPixelValue: self segmentBackgroundColor ] ]).
				
		self imageFromBits: bits ].
	
]

{ #category : #segmentation }
AIImageSegmentator >> buildSegmentedImage [

	| bits |

	bits := Bitmap withAll:
		(self clusters collect: [ :cluster |
			self colorAsPixelValue: (self clusterColors at: cluster) ]).
		
	^ self imageFromBits: bits
	
]

{ #category : #accessing }
AIImageSegmentator >> clusterColors [

	^ clusteringModel centroids collect: [ :each |
		Color fromRgbTriplet: each ].
]

{ #category : #segmentation }
AIImageSegmentator >> clusterImagePixels [

	| data |

	data := originalImage bits asOrderedCollection collect: [ :pixelValue |
		self pixelValueAsRGBArray: pixelValue ].

	clusteringModel := (AIKMeans numberOfClusters: numberOfSegments)
		timesToRun: 1;
		yourself.
		
	clusteringModel fit: data.
]

{ #category : #accessing }
AIImageSegmentator >> clusters [

	^ clusteringModel clusters
]

{ #category : #colors }
AIImageSegmentator >> colorAsPixelValue: aColor [

	^ aColor pixelValueForDepth: self depth
]

{ #category : #accessing }
AIImageSegmentator >> depth [

	^ originalImage depth
]

{ #category : #accessing }
AIImageSegmentator >> image: aForm [

	originalImage := aForm
]

{ #category : #segmentation }
AIImageSegmentator >> imageFromBits: aCollectionOfPixelValues [

	^ Form
		extent: originalImage extent
		depth: self depth
		bits: aCollectionOfPixelValues.
]

{ #category : #initialization }
AIImageSegmentator >> initialize [
	super initialize.
	whiteOnBlackSegments := false.
]

{ #category : #loading }
AIImageSegmentator >> loadImage: aFileReference [

	aFileReference binaryReadStreamDo: [ :stream |
		originalImage := ImageReadWriter formFromStream: stream ].
]

{ #category : #accessing }
AIImageSegmentator >> numberOfSegments: anInteger [

	numberOfSegments := anInteger
]

{ #category : #displaying }
AIImageSegmentator >> openAll [

	self class openImagePresenter: originalImage title: 'Original Image'.
	self class openImagePresenter: segmentedImage title: 'Segmented image'.

	segments doWithIndex: [ :segment :i | 
		self class openImagePresenter: segment title: 'Segment ' , i asString ]
]

{ #category : #accessing }
AIImageSegmentator >> originalImage [

	^ originalImage
]

{ #category : #colors }
AIImageSegmentator >> pixelValueAsRGBArray: anInteger [

	| color |
	color := anInteger asColorOfDepth: self depth.
	^ { color red . color green . color blue }
]

{ #category : #colors }
AIImageSegmentator >> segmentBackgroundColor [

	^ whiteOnBlackSegments
		ifTrue: [ Color black ]
		ifFalse: [ Color white ]
]

{ #category : #colors }
AIImageSegmentator >> segmentFillColor: aSegmentIndex [

	^ whiteOnBlackSegments
		ifTrue: [ Color white ]
		ifFalse: [ self clusterColors at: aSegmentIndex ]
]

{ #category : #segmentation }
AIImageSegmentator >> segmentate [

	clusteringModel ifNil: [
		self error: 'You must call clusterImagePixels first' ].
	
	segmentedImage := self buildSegmentedImage.
	segments := self buildIndividualSegmentImages.
]

{ #category : #accessing }
AIImageSegmentator >> segmentedImage [

	^ segmentedImage
]

{ #category : #accessing }
AIImageSegmentator >> segments [

	^ segments
]

{ #category : #accessing }
AIImageSegmentator >> whiteOnBlackSegments: aBoolean [

	whiteOnBlackSegments := aBoolean
]
