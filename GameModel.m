//
//  GameModel.m
//  ETF_Blackjack
//
//  Created by Student on 9/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "GameModel.h"
#import "SoundEffects.h"
@import AVFoundation;

@implementation GameModel{
    NSMutableArray *_cards;
    NSMutableArray *_playerCards;
    NSMutableArray *_dealerCards;
    BOOL _didDealerWin;
    SoundEffects *_soundEffects;
}

-(PlayingCard *)nextCard{
    PlayingCard *card = _cards[0];
    [_cards removeObjectAtIndex:0];
    return card;
}

#pragma mark - Helper Methods
-(NSMutableArray *)shuffle:(NSMutableArray *)array{
    int i, randomPosition;
    int numElements = [array count];
    id tempElement;
    
    for(i = 0; i<numElements; i++){
        randomPosition = arc4random_uniform(numElements);
        tempElement = array[i];
        array[i] = array[randomPosition];
        array[randomPosition] = tempElement;
    }
    return array;
}

// public
-(PlayingCard *)drawDealerCard{
    PlayingCard *card = [self nextCard];
    [_dealerCards addObject:card];
    return card;
}

-(PlayingCard *)drawPlayerCard{
    PlayingCard *card = [self nextCard];
    [_playerCards addObject:card];
    return card;
}

-(PlayingCard *)lastDealerCard{
    if (_dealerCards.count > 0) return [_dealerCards lastObject];
    return nil;
}

-(PlayingCard *)lastPlayerCard{
    if (_playerCards.count > 0) return [_playerCards lastObject];
    return nil;
}

-(PlayingCard *)playerCardAtIndex:(int)index{
    if (index < _playerCards.count) return _playerCards[index];
    return nil;
}

-(PlayingCard *)dealerCardAtIndex:(int)index{
    if (index < _dealerCards.count) return _dealerCards[index];
    return nil;
}

-(void)dealNewHand{
    _cards = [PlayingCard createDeck];
    [self shuffle: _cards];
    _playerCards = [NSMutableArray array];
    _dealerCards = [NSMutableArray array];
    self.gameStage = kGameStagePlayer;
}

-(void)updateGameStage{
    // game logic goes here
    if(_gameStage == kGameStagePlayer){
        //hand over if player busted
        if([self areCardsBust:_playerCards]){
            _gameStage = kGameStageGameOver;
            _didDealerWin = YES;
            [_soundEffects playLoseSound];
            [self notifyGameDidEnd];
        }
        //player done if they have drawn 5 cards
        else if(_playerCards.count == kMAX_PLAYER_CARDS){
            _gameStage = kGameStageDealer;
        }
        return;
    } //end if kGameStagePlayer
    if(_gameStage == kGameStageDealer){
        //hand over if dealer busted
        if([self areCardsBust:_dealerCards]){
            self.gameStage = kGameStageGameOver;
            _didDealerWin = NO;
            [self notifyGameDidEnd];
        }
        //dealer done if they have drawn 5 cards
        else if([_dealerCards count] == kMAX_PLAYER_CARDS){
            _gameStage = kGameStageGameOver;
            [self calculateWinner];
            [self notifyGameDidEnd];
        }
        else{
            //should the dealer stop, has he won?
            int dealerScore = [self calculateBestScore:_dealerCards];
            if(dealerScore >= 17){
                int playerScore = [self calculateBestScore:_playerCards];
                
                if(playerScore > dealerScore){
                    //dealer must play again as he's not equal or better than the player's score
                    //keep playing, dealer will play another card
                }
                else{
                    //dealer has equaled or beaten the player so the game is over
                    _didDealerWin = YES;
                    _gameStage = kGameStageGameOver;
                    [self notifyGameDidEnd];
                }
            }
        }
    } //end if kGameStageDealer
}

-(NSString *)description{
    NSMutableString *s = [NSMutableString string];
    [s appendFormat:@"Dealer Cards = %@", _dealerCards];
    [s appendFormat:@"Player Cards = %@", _playerCards];
    [s appendFormat:@"Game Stage = %d", self.gameStage];
    
    return s;
}

-(BOOL)areCardsBust:(NSMutableArray *)cards{
    PlayingCard *card;
    int lowestScore = 0;
    for(int i = 0; i<cards.count; i++){
        card = cards[i];
        if(card.isAnAce){
            lowestScore += 1;
        }
        else if (card.isAFaceOrTenCard){
            lowestScore += 10;
        }
        else{
            lowestScore += card.value;
        }
    }
    if(lowestScore > 21) return YES;
    return NO;
}

-(BOOL)calculateBestScore:(NSMutableArray *)cards{
    if([self areCardsBust:cards]){
        return 0;
    }
    //we have a hand of 21 or less then...
    PlayingCard *card;
    int highestScore = 0;
    int maxLoop = [cards count];
    for(int i = 0; i<maxLoop; i++){
        card = cards[i];
        if(card.isAnAce) {
            highestScore += 11;
        }
        else if (card.isAFaceOrTenCard){
            highestScore += 10;
        }
        else{
            highestScore += card.value;
        }
    }
    //knock down score for aces
    while(highestScore > 21){
        highestScore -= 10;
    }
    return highestScore;
}

-(void)calculateWinner{
    int dealerScore = [self calculateBestScore:_dealerCards];
    int playerScore = [self calculateBestScore:_playerCards];
    
    _didDealerWin = (playerScore > dealerScore) ? NO : YES;
}

-(void)notifyGameDidEnd{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //wrap a boolean into an NSNumber object using literals syntax
    NSNumber *didDealerWin = @(_didDealerWin);
    //create a dictionary using literals syntax
    NSDictionary *dict = @{@"didDealerWin": didDealerWin};
    //"publish" notification
    [notificationCenter postNotificationName:kNotificationGameDidEnd object:self userInfo:dict];
}

@end
