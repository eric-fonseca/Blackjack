//
//  GameModel.h
//  ETF_Blackjack
//
//  Created by Student on 9/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"

static const int kMAX_PLAYER_CARDS = 5;
static NSString *kNotificationGameDidEnd = @"kNotificationGameDidEnd";

typedef enum : int{
    kGameStagePlayer,
    kGameStageDealer,
    kGameStageGameOver
}kGameStage;

@interface GameModel : NSObject
@property (nonatomic) kGameStage gameStage;

-(void)dealNewHand;
-(void)updateGameStage;
-(PlayingCard *)drawDealerCard;
-(PlayingCard *)drawPlayerCard;
-(PlayingCard *)lastDealerCard;
-(PlayingCard *)lastPlayerCard;
-(PlayingCard *)playerCardAtIndex:(int)index;
-(PlayingCard *)dealerCardAtIndex:(int)index;

@end
