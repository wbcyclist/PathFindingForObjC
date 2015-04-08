PathFindingForObjC
===================

A Comprehensive PathFinding Library for Objective-C.  
Based on [PathFinding.js](https://github.com/qiao/PathFinding.js) by [@qiao](https://github.com/qiao).

## Installation
---
#### Cocoapods
* Edit your Podfile
``` ruby
pod 'PathFindingForObjC'
```
or use the `master` branch of the repo :
``` ruby
pod 'PathFindingForObjC', :git => 'https://github.com/wbcyclist/PathFindingForObjC.git'
```

* Add `#import <PathFindingForObjC/PathFinding.h>` to your source file.

> **Disable logging**
> 
> add this code in `Podfile`
> ``` ruby
post_install do |installer|
	installer.project.targets.each do |target|
		target.build_configurations.each do |config|
			if target.name.include? 'PathFindingForObjC'
				preprocessorMacros = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
				if preprocessorMacros.nil?
					preprocessorMacros = ['$(inherited)', 'COCOAPODS=1'];
				end
				preprocessorMacros << 'PF_DEBUG=0'
				config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = preprocessorMacros
			end
		end
	end
end
> ```

#### Manually
1. Download the [latest code version](https://github.com/wbcyclist/PathFindingForObjC/archive/master.zip) or add the repository as a git submodule to your git-tracked project. 
1. Open your project in Xcode, then drag and drop `PathFindingForObjC/PathFindingForObjC` into your project 
2. Add `#import PathFinding.h` to your source file.

> **Disable logging**
>
> Click on your `Project` Target, head over to `Build Settings` and search for `Preprocessor Macros`. add `PF_DEBUG=0` to `Debug` Configuration.
![](https://raw.githubusercontent.com/wbcyclist/PathFindingForObjC/master/demo/Screenshot_01.png)

## Basic Usage
---
``` objective-c
PathFinding *finder = [[PathFinding alloc] initWithMapSize:CGSizeMake(6, 5)
												  tileSize:CGSizeMake(1, 1)
											   coordsOrgin:CGPointZero];
finder.heuristicType = HeuristicTypeManhattan;
finder.movementType = DiagonalMovement_Never;

// add blocks
[finder addBlockTilePositions:@[PF_CGPointToNSValue(CGPointMake(1, 2)),
								PF_CGPointToNSValue(CGPointMake(2, 2)),
								PF_CGPointToNSValue(CGPointMake(3, 2))
								]];
// set start point
finder.startPoint = CGPointMake(2, 3);
// set end point
finder.endPoint = CGPointMake(2, 1);
// get result
NSArray *foundPaths = [finder findPathing:PathfindingAlgorithm_AStar IsConvertToOriginCoords:YES];
```
##### debug log:
>:mag:	:mag:	:mag:	:mag:	:mag:	:mag:

>:mag:	:mag:	:pray:	:heartpulse:	:heartpulse:	:mag:

>:mag:	:underage:	:underage:	:underage:	:heartpulse:	:mag:

>:mag:	:mag:	:no_good:	:heartpulse:	:heartpulse:	:mag:

>:mag:	:mag:	:mag:	:mag:	:mag:	:mag:

#### Options
`HeuristicType` :
* HeuristicTypeManhattan
* HeuristicTypeEuclidean
* HeuristicTypeOctile
* HeuristicTypeChebyshev

`DiagonalMovement` :
* DiagonalMovement_Always
* DiagonalMovement_Never
* DiagonalMovement_IfAtMostOneObstacle
* DiagonalMovement_OnlyWhenNoObstacles

`PathfindingAlgorithm` :
* PathfindingAlgorithm_AStar
* PathfindingAlgorithm_BestFirstSearch
* PathfindingAlgorithm_Dijkstra
* PathfindingAlgorithm_JumpPointSearch
* PathfindingAlgorithm_BreadthFirstSearch
* PathfindingAlgorithm_BiAStar
* PathfindingAlgorithm_BiBestFirst
* PathfindingAlgorithm_BiDijkstra
* PathfindingAlgorithm_BiBreadthFirst



##DEMO
---
[Download](https://raw.githubusercontent.com/wbcyclist/PathFindingForObjC/master/demo/PathFinding-Mac.zip)
<p align="center" >
<img src="https://raw.githubusercontent.com/wbcyclist/PathFindingForObjC/master/demo/PathFinding_ScreenShot.png" alt="OS X" width="858px" style="width:858px;"/>
</p>
<p align="center" >
<img src="https://raw.githubusercontent.com/wbcyclist/PathFindingForObjC/master/demo/PathFinding_ScreenShot_iOS.png" alt="iOS" width="858px" style="width:858px;"/>
</p>
License
-----------
* MIT
