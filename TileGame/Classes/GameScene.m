//
//  GameScene.m
//  TileGame
//
//  Created by Daniel Witurna on 19.07.14.
//  Copyright Daniel Witurna 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "GameScene.h"

// -----------------------------------------------------------------------
#pragma mark - GameScene
// -----------------------------------------------------------------------

@interface GameScene ()

@property (strong) CCNode *contentNode;
@property (strong) CCTiledMap *tileMap;
@property (strong) CCTiledMapLayer *background;
@property (strong) CCSprite *player;

@end

@implementation GameScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (GameScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    if (self) {
        // Enable touch handling on scene node
        self.userInteractionEnabled = YES;
        
        _contentNode = [CCNode node];
        _contentNode.userInteractionEnabled = YES;
        _contentNode.multipleTouchEnabled = YES;
        _contentNode.contentSizeType = CCSizeTypeNormalized;
        _contentNode.contentSize = CGSizeMake(1, 1);
        [self addChild:_contentNode];
        
        _tileMap = [CCTiledMap tiledMapWithFile:@"TileMap.tmx"];
        _background = [_tileMap layerNamed:@"Background"];
        
        [_contentNode addChild:_tileMap z:-1];
        
        CCTiledMapObjectGroup *objectGroup = [_tileMap objectGroupNamed:@"Objects"];
        NSAssert(objectGroup != nil, @"tile map has no objects object layer");
        
        NSDictionary *spawnPoint = [objectGroup objectNamed:@"SpawnPoint"];
        NSInteger x = [spawnPoint[@"x"] integerValue];
        NSInteger y = [spawnPoint[@"y"] integerValue];
        
        _player = [CCSprite spriteWithImageNamed:@"Player.png"];
        _player.position = ccp(x, y);
        
        [_contentNode addChild:_player];
        [self setViewPointCenter:_player.position];
    }

    return self;
}

- (void)setViewPointCenter:(CGPoint) position {
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    
    int x = MAX(position.x, winSize.width/2);
    int y = MAX(position.y, winSize.height/2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width) - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height) - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.contentNode.position = viewPoint;
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - handle touches
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:self.tileMap];
    
    CGPoint playerPos = _player.position;
    CGPoint diff = ccpSub(touchLocation, playerPos);
    
    if ( abs(diff.x) > abs(diff.y) ) {
        if (diff.x > 0) {
            playerPos.x += _tileMap.tileSize.width;
        } else {
            playerPos.x -= _tileMap.tileSize.width;
        }
    } else {
        if (diff.y > 0) {
            playerPos.y += _tileMap.tileSize.height;
        } else {
            playerPos.y -= _tileMap.tileSize.height;
        }
    }
    
    CCLOG(@"playerPos %@",CGPointCreateDictionaryRepresentation(playerPos));
    
    // safety check on the bounds of the map
    if (playerPos.x <= (_tileMap.mapSize.width * _tileMap.tileSize.width) &&
        playerPos.y <= (_tileMap.mapSize.height * _tileMap.tileSize.height) &&
        playerPos.y >= 0 &&
        playerPos.x >= 0 )
    {
        [self setPlayerPosition:playerPos];
    }
    
    [self setViewPointCenter:_player.position];
}

-(void)setPlayerPosition:(CGPoint)position {
	_player.position = position;
}


@end
