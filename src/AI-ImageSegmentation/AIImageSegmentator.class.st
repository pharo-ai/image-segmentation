Class {
	#name : #AIImageSegmentator,
	#superclass : #Object,
	#instVars : [
		'originalImage',
		'segmentedImage',
		'segments',
		'clusters',
		'numberOfSegments',
		'clusterColors'
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

{ #category : #colors }
AIImageSegmentator >> blackPixelValue [

	^ self colorAsPixelValue: Color black
]

{ #category : #segmentation }
AIImageSegmentator >> buildIndividualSegmentImages [

	| bits |

	^ (1 to: numberOfSegments) collect: [ :i |
    	bits := Bitmap withAll:
			(clusters collect: [ :cluster |
				cluster = i
					ifTrue: [ self colorAsPixelValue: (clusterColors at: cluster) ]
					ifFalse: [ self whitePixelValue ] ]).
				
		self imageFromBits: bits ].
	
]

{ #category : #segmentation }
AIImageSegmentator >> buildSegmentedImage [

	| bits |

	bits := Bitmap withAll:
		(clusters collect: [ :cluster |
			self colorAsPixelValue: (clusterColors at: cluster) ]).
		
	^ self imageFromBits: bits
	
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

	| pixelData model |

	pixelData := originalImage bits asOrderedCollection collect: [ :pixelValue |
		self pixelValueAsRGBArray: pixelValue ].

	model := AIKMeans numberOfClusters: numberOfSegments.
	model timesToRun: 1.
	model fit: pixelData.
	
	clusters := model clusters.
	
	clusterColors := model centroids collect: [ :each |
		Color fromRgbTriplet: each ].
]

{ #category : #segmentation }
AIImageSegmentator >> imageFromBits: aCollectionOfPixelValues [

	^ Form
		extent: originalImage extent
		depth: self depth
		bits: aCollectionOfPixelValues.
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

{ #category : #colors }
AIImageSegmentator >> whitePixelValue [

	^ self colorAsPixelValue: Color white
]
