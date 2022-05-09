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

{ #category : #segmentation }
AIImageSegmentator >> buildIndividualSegmentImages [

	| bits |

	^ (1 to: numberOfSegments) collect: [ :i |
    	bits := Bitmap withAll:
			(clusteringModel clusters collect: [ :cluster |
				cluster = i
					ifTrue: [ self colorAsPixelValue: (self segmentFillColor: i) ]
					ifFalse: [ self colorAsPixelValue: self segmentBackgroundColor ] ]).
				
		self imageFromBits: bits ].
	
]

{ #category : #segmentation }
AIImageSegmentator >> buildSegmentedImage [

	| bits |

	bits := Bitmap withAll:
		(clusteringModel clusters collect: [ :cluster |
			self colorAsPixelValue: (self clusterColors at: cluster) ]).
		
	^ self imageFromBits: bits
	
]

{ #category : #accessing }
AIImageSegmentator >> clusterColors [

	^ clusteringModel centroids collect: [ :each |
		Color fromRgbTriplet: each ].
]

{ #category : #colors }
AIImageSegmentator >> colorAsPixelValue: aColor [

	^ aColor pixelValueForDepth: self depth
]

{ #category : #accessing }
AIImageSegmentator >> depth [

	^ originalImage depth
]

{ #category : #segmentation }
AIImageSegmentator >> findPixelClusters [

	| data |

	data := originalImage bits asOrderedCollection collect: [ :pixelValue |
		self pixelValueAsRGBArray: pixelValue ].

	clusteringModel := (AIKMeans numberOfClusters: numberOfSegments)
		timesToRun: 1;
		yourself.
		
	clusteringModel fit: data.
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

	AIImagePresenter openImage: originalImage title: 'Original Image'.
	AIImagePresenter openImage: segmentedImage title: 'Segmented Image'.

	segments doWithIndex: [ :segment :i |
		AIImagePresenter openImage: segment title: ('Segment ', i asString) ].
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

	self findPixelClusters.
	
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
