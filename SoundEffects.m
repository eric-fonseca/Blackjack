//
//  SoundEffects.m
//  ETF_Blackjack
//
//  Created by Eric on 10/4/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

@import AVFoundation;
#import "SoundEffects.h"

@implementation SoundEffects{
    AVAudioPlayer *_drawCard; //player/dealer receives a new card
    AVAudioPlayer *_win; //won a round
    AVAudioPlayer *_lose; //lost a round
    AVAudioPlayer *_shuffle; //start of every game
}

-(void)playDrawCardSound{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{ //do this once!
        _drawCard = [[AVAudioPlayer alloc] init];
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"flipcard" ofType:@"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        NSError *error;
        _drawCard = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        if(error)NSLog(@"error loading sound file! error = %@",error);
        _drawCard.volume = 1.0;
    });
    
    [_drawCard play];
}

-(void)playWinSound{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _win = [[AVAudioPlayer alloc] init];
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"PowerUp" ofType:@"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        NSError *error;
        _win = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        if(error)NSLog(@"error loading sound file! error = %@",error);
        _win.volume = 1.0;
    });
    
    [_win play];
}

-(void)playLoseSound{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _lose = [[AVAudioPlayer alloc] init];
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"losthand" ofType:@"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        NSError *error;
        _lose = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        if(error)NSLog(@"error loading sound file! error = %@",error);
        _lose.volume = 1.0;
    });
        
    [_lose play];
}

-(void)playShuffleSound{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _shuffle = [[AVAudioPlayer alloc] init];
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"shuffling-cards-1" ofType:@"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        NSError *error;
        _shuffle = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        if(error)NSLog(@"error loading sound file! error = %@",error);
        _shuffle.volume = 1.0;
    });
        
    [_shuffle play];
}

@end
