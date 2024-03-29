# Example of Image Segmentation Using K-Means

[![Build status](https://github.com/pharo-ai/image-segmentation/workflows/CI/badge.svg)](https://github.com/pharo-ai/image-segmentation/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/pharo-ai/image-segmentation/badge.svg?branch=master)](https://coveralls.io/github/pharo-ai/image-segmentation?branch=master)
[![Pharo version](https://img.shields.io/badge/Pharo-9-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-10-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/pharo-ai/image-segmentation/master/LICENSE)

Example of image segmentation in [Pharo](https://pharo.org) based on [k-means clustering](https://github.com/pharo-ai/k-means).

Look at our tutorial on the pharo wiki of how to use this project! https://github.com/pharo-ai/wiki/blob/master/wiki/Tutorials/image-segmentation-using-kmeans.md

## How to install it

To install `image-segmentation`, go to the Playground (Ctrl+OW) in your [Pharo](https://pharo.org/) image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```Smalltalk
Metacello new
  baseline: 'AIImageSegmentation';
  repository: 'github://pharo-ai/image-segmentation';
  load.
```

## How to depend on it

If you want to add a dependency, include the following lines into your baseline method:

```Smalltalk
spec
  baseline: 'AIImageSegmentation'
  with: [ spec repository: 'github://pharo-ai/image-segmentation' ].
```

## How to use it

```st
file := 'pharo-local/iceberg/pharo-ai/image-segmentation/img/renoir_river.jpg' asFileReference.
```

```st
segmentator := AIImageSegmentator new
  loadImage: file;
  numberOfSegments: 3;
  yourself.
```

```st
segmentator clusterImagePixels.
segmentator segmentate.

segmentator segmentatedImage.
```

![](https://github.com/pharo-ai/wiki/blob/master/wiki/Tutorials/img/segmented-renoir-river.png?raw=true)

```st
segmentator segments.
segmentator openAll.
```

![](https://github.com/pharo-ai/wiki/blob/master/wiki/Tutorials/img/renoir-river-all-segments.png?raw=true)
