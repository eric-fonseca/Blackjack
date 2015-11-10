//
//  ETF_BlackjackTests.m
//  ETF_BlackjackTests
//
//  Created by Student on 9/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlayingCard.h"

@interface ETF_BlackjackTests : XCTestCase

@end

@implementation ETF_BlackjackTests{
    PlayingCard *_playingCard;
    NSMutableArray *_deck;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _playingCard = [[PlayingCard alloc] init];
    _deck = [PlayingCard createDeck];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testPlayingCard_allocInit_resultNotNil{
    XCTAssertNotNil(_playingCard, @"_playingCard is nil");
}

-(void)testPlayingCard_createDeck_resultNotNil{
    XCTAssertNotNil(_deck, @"_deck is nil");
}

-(void)testPlayingCard_deckLength_52Cards{
    XCTAssertTrue(_deck.count == 52, @"_deck.count != 52");
}

-(void)testPlayingCard_setSuit_suitSet{
    _playingCard.suit = PlayingCardSuitClub;
    XCTAssertTrue(_playingCard.suit == PlayingCardSuitClub, @"_playingCard.suit property not set");
}

-(void)testPlayingCard_setValue_valueSet{
    _playingCard.value = 10;
    XCTAssertTrue(_playingCard.value == 10, @"_playingCard.value property not set");
}

-(void)testPlayingCard_isAFaceOrTenCard_11isaFaceCard{
    PlayingCard *card = [[PlayingCard alloc]init];
    card.value = 11;
    XCTAssertTrue(card.isAFaceOrTenCard == TRUE, @"card.value of 11 is supposed to be a face card");
}


@end
