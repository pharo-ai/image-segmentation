# Example of Image Segmentation Using K-Means

[![Build status](https://github.com/pharo-ai/image-segmentation/workflows/CI/badge.svg)](https://github.com/pharo-ai/image-segmentation/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/pharo-ai/image-segmentation/badge.svg?branch=master)](https://coveralls.io/github/pharo-ai/image-segmentation?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/pharo-ai/image-segmentation/master/LICENSE)

Example of image segmentation in [Pharo](https://pharo.org) based on [k-means clustering](https://github.com/pharo-ai/k-means).

## How to install it

To install `image-segmentation`, go to the Playground (Ctrl+OW) in your [Pharo](https://pharo.org/) image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```Smalltalk
Metacello new
  baseline: 'AIImageSegmentation';
  repository: 'github://pharo-ai/image-segmentation';
  load.
```

## How to depend on it

If you want to add a dependency on `linear-algebra` to your project, include the following lines into your baseline method:

```Smalltalk
spec
  baseline: 'AIImageSegmentation'
  with: [ spec repository: 'github://pharo-ai/image-segmentation' ].
```

## How to use it

```st
file := AIImageSegmentator imageDirectory / 'stamp.jpg'.

segmentator := AIImageSegmentator new
  loadImage: file;
  numberOfSegments: 2;
  yourself.
	
segmentator segmentate.
segmentator openAll.
```
