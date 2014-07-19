//
//  GameScene.h
//  TileGame
//
//  Created by Daniel Witurna on 19.07.14.
//  Copyright Daniel Witurna 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using cocos2d-v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The Game scene
 */
@interface GameScene : CCScene

// -----------------------------------------------------------------------

+ (GameScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end