//
//  PlayingCard.h
//  ETF_Blackjack
//
//  Created by Student on 9/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : int{
    PlayingCardSuitClub,
    PlayingCardSuitSpade,
    PlayingCardSuitDiamond,
    PlayingCardSuitHeart
}PlayingCardSuit;

@interface PlayingCard : NSObject
//public properties
@property (nonatomic) PlayingCardSuit suit;
@property (nonatomic) int value;
@property (nonatomic) BOOL isFaceUp;

//public instance methods
-(BOOL) isAnAce;
-(BOOL) isAFaceOrTenCard;

//public class method
+(NSMutableArray *)createDeck;
-(UIImage *)getCardImage;

@end
