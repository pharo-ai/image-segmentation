Class {
	#name : #BaselineOfAIImageSegmentation,
	#superclass : #BaselineOf,
	#category : #BaselineOfAIImageSegmentation
}

{ #category : #baselines }
BaselineOfAIImageSegmentation >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"External dependencies"
		spec
    		baseline: 'AIKMeans'
    		with: [ spec repository: 'github://pharo-ai/k-means' ].
			
		"Packages"
		spec
			package: 'AI-ImageSegmentation' with: [ spec requires: #('AIKMeans') ];
			package: 'AI-ImageSegmentation-Tests' with: [ spec requires: #( 'AI-ImageSegmentation' ) ] ]
]
