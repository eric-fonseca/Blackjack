//
//  PlayingCard.m
//  ETF_Blackjack
//
//  Created by Student on 9/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(BOOL)isAnAce{
    if (self.value == 1) return YES;
    return NO;
}

-(BOOL)isAFaceOrTenCard{
    if (self.value == 10 || self.value == 11 || self.value == 12 || self.value == 13){
        return YES;
    }
    return NO;
}

+(NSMutableArray *) createDeck{
    NSMutableArray *array = [NSMutableArray array];
    PlayingCard *card;
    int suit, value;
    
    for(suit = 0; suit<4; suit++){
        for(value=1;value<=13;value++){
            card = [[PlayingCard alloc] init];
            card.suit = suit;
            card.value = value;
            [array addObject:card];
        }
    }
    return array;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%d of %d", self.value, self.suit];
}

-(UIImage *)getCardImage{
    NSString *suit;
    
    switch (self.suit) {
        case PlayingCardSuitClub:
            suit = @"clubs";
            break;
            
        case PlayingCardSuitSpade:
            suit = @"spades";
            break;
            
        case PlayingCardSuitDiamond:
            suit = @"diamonds";
            break;
            
        case PlayingCardSuitHeart:
            suit = @"hearts";
            break;
            
        default:
            break;
    }
    
    NSString *filename = [NSString stringWithFormat:@"%@-%d-236x352.png",suit,self.value];
    UIImage *image = [UIImage imageNamed:filename];
    return image;
}

@end
