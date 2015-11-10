//
//  SoundEffects.h
//  ETF_Blackjack
//
//  Created by Eric on 10/4/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundEffects : NSObject

-(void)playDrawCardSound;
-(void)playWinSound;
-(void)playLoseSound;
-(void)playShuffleSound;

@end
