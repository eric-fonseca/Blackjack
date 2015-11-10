//
//  ViewController.m
//  ETF_Blackjack
//
//  Created by Student on 9/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "ViewController.h"
#import "GameModel.h"
#import "SoundEffects.h"
@import AVFoundation;

static const int kSTART_TAG_DEALER_VIEW = 100;
static const int kSTART_TAG_PLAYER_VIEW = 200;
static const int kNUM_CARDS = 5;
static NSString *kCARD_BACK_IMAGE = @"card-back-236x352.png";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *standButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;

@end

@implementation ViewController{
    GameModel *_gameModel;
    SoundEffects *_soundEffects;
    NSMutableArray *_playerCardViews, *_dealerCardViews;
    IBOutlet UILabel *_cash;
    IBOutlet UILabel *_round;
    IBOutlet UILabel *_status;
    IBOutlet UILabel *_bet;
    int _totalCash; //total money
    int _roundNumber; //current round
    int _betAmount; //your bet
    NSString *_cardValue;
    NSString *_cardSuit;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _totalCash = 100; //start the player with $100
    _roundNumber = 1; //start on round 1
    _betAmount = 50; //default bet is $50
    
    for(int i = 0; i<kNUM_CARDS; i++){
        UIView *dealerCardView = [self.view viewWithTag:i+kSTART_TAG_DEALER_VIEW];
        UIView *playerCardView = [self.view viewWithTag:i+kSTART_TAG_PLAYER_VIEW];
        [_dealerCardViews addObject:dealerCardView];
        [_playerCardViews addObject:playerCardView];
    }
    NSAssert(_dealerCardViews.count == kNUM_CARDS, @"_dealerCardViews.count=%d", _dealerCardViews.count);
    NSAssert(_playerCardViews.count == kNUM_CARDS, @"_playerCardViews.count=%d", _playerCardViews.count);
    
    self.hitButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.hitButton.layer.borderWidth = 1.0;
    self.hitButton.layer.cornerRadius = 10;
    self.hitButton.backgroundColor = [UIColor whiteColor];
    
    self.standButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.standButton.layer.borderWidth = 1.0;
    self.standButton.layer.cornerRadius = 10;
    self.standButton.backgroundColor = [UIColor whiteColor];
    
    //self.aboutButton.layer.borderColor = [UIColor blackColor].CGColor;
    //self.aboutButton.layer.borderWidth = 1.0;
    //.cornerRadius of 1/2 the width of the button makes it round
    //self.aboutButton.layer.cornerRadius = 20;
    //self.aboutButton.backgroundColor = [UIColor whiteColor];
    
    _status.text = @"You can choose to hit or stand";
    _cash.text = [NSString stringWithFormat:@"Cash: $%d",_totalCash];
    _round.text = [NSString stringWithFormat:@"Round: %d",_roundNumber];
    _bet.text = [NSString stringWithFormat:@"Bet: $%d",_betAmount];
    
    [_soundEffects playShuffleSound];
    [self restartGame];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - Actions
- (IBAction)hitButtonTapped:(id)sender{
    PlayingCard *card = [_gameModel drawPlayerCard];
    
    //determine what suit each card is
    if(card.suit == 0){
         _cardSuit = @"Clubs";
    }
    else if(card.suit == 1){
        _cardSuit = @"Spades";
    }
    else if(card.suit == 2){
        _cardSuit = @"Diamonds";
    }
    else{
        _cardSuit = @"Hearts";
    }
    
    //change card values to actual names
    if(card.value == 11){
        _cardValue = @"Jack";
    }
    else if(card.value == 12){
        _cardValue = @"Queen";
    }
    else if(card.value == 13){
        _cardValue = @"King";
    }
    else if(card.value == 1){
        _cardValue = @"Ace";
    }
    else{
        _cardValue = [NSString stringWithFormat:@"%d",card.value];
    }
    
    //update status label with the card value and suit
    _status.text = [NSString stringWithFormat:@"You drew: %@ of %@", _cardValue, _cardSuit];
    card.isFaceUp = YES;
    [self updateView];
    [_soundEffects playDrawCardSound];
    [_gameModel updateGameStage];
    if (_gameModel.gameStage == kGameStageDealer){
        [self playDealerTurn];
    }
}

- (IBAction)standButtonTapped:(id)sender{
    _gameModel.gameStage = kGameStageDealer;
    [self playDealerTurn];
}

//clicking up arrow
- (IBAction)plusButtonTapped:(id)sender{
    if(_betAmount<_totalCash){ //prevent player from betting more than they have
        _betAmount += 5; //raise bet in increments of $5
        if(_betAmount == _totalCash){ //you're betting all of your money! Prevent the player from betting any more
            [_plusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal]; //fade out button
            _plusButton.enabled = NO; //disable animation
        }
        else{
            [_plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _plusButton.enabled = YES;
        }
    }
    if(_betAmount == 5){ //minimum bet reached! Prevent player from decreasing bet any further
        [_minusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _minusButton.enabled = NO;
    }
    else{
        [_minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _minusButton.enabled = YES;
    }
    _bet.text = [NSString stringWithFormat:@"Bet: $%d",_betAmount];
}

//clicking down arrow
- (IBAction)minusButtonTapped:(id)sender{
    if(_betAmount > 5){ //Prevent player from betting less than $5
        _betAmount -= 5; //decrease bet in increments of $5
        if(_betAmount == 5){
            [_minusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _minusButton.enabled = NO;
        }
        else{
            [_minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _minusButton.enabled = YES;
        }
    }
    if(_betAmount == _totalCash){
        [_plusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _plusButton.enabled = NO;
    }
    else{
        [_plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _plusButton.enabled = YES;
    }
    _bet.text = [NSString stringWithFormat:@"Bet: $%d",_betAmount];
}

#pragma mark - Private Methods
- (void)playDealerTurn{
    self.standButton.enabled = self.hitButton.enabled = NO;
    [self performSelector:@selector(showSecondDealerCard) withObject:nil afterDelay:0.8];
}

- (void)showSecondDealerCard{
    PlayingCard *card = [_gameModel lastDealerCard];
    card.isFaceUp = YES;
    [self updateView];
    [_soundEffects playDrawCardSound];
    [_gameModel updateGameStage];
    if (_gameModel.gameStage != kGameStageGameOver){
        [self performSelector:@selector(showNextDealerCard) withObject:nil afterDelay:0.8];
    }
}

- (void)showNextDealerCard{
    //next card
    PlayingCard *card = [_gameModel drawDealerCard];
    card.isFaceUp = YES;
    [self updateView];
    [_soundEffects playDrawCardSound];
    [_gameModel updateGameStage];
    if (_gameModel.gameStage != kGameStageGameOver){
        [self performSelector:@selector(showNextDealerCard) withObject:nil afterDelay:0.8];
    }
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    //NSLog(@"%s", __FUNCTION__);
    self = [super initWithCoder:aDecoder];
    if(self){
        _gameModel = [[GameModel alloc] init];
        _soundEffects = [[SoundEffects alloc] init];
        _dealerCardViews = [NSMutableArray array];
        _playerCardViews = [NSMutableArray array];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotificationGameDidEnd:) name:kNotificationGameDidEnd object:_gameModel];
    
    return self;
}

#pragma mark - Notifications
- (void) handleNotificationGameDidEnd:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *num = userInfo[@"didDealerWin"];
    NSString *message = [num boolValue] ? [NSString stringWithFormat:@"Sorry! You lost $%d",_betAmount] : [NSString stringWithFormat:@"Nice job! You won $%d!",_betAmount]; //tell player how much they won/lost each turn
    if([message isEqualToString:[NSString stringWithFormat:@"Sorry! You lost $%d",_betAmount]]){ //if they lost, do the following:
        _totalCash -= _betAmount; //decrease the player's cash by how much they bet
        [_soundEffects playLoseSound];
        _status.text = @"The dealer won the last hand"; //update status label
        if(_betAmount > _totalCash){ //prevents the bet from being stuck higher than the player actually has
            _betAmount = _totalCash;
            _bet.text = [NSString stringWithFormat:@"Bet: $%d",_betAmount];
            [_plusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _plusButton.enabled = NO;
        }
    }
    else if([message isEqualToString:[NSString stringWithFormat:@"Nice job! You won $%d!",_betAmount]]){ //if they won, do the following:
        _totalCash += _betAmount; //increase the player's cash by how much they bet
        [_soundEffects playWinSound];
        _status.text = @"You won the last hand";
        [_plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; //enable the plus button because they have more to spend! Useful if the player bet all of their money in one round
        _plusButton.enabled = YES;
    }
    if(_roundNumber==5 || _totalCash <= 0){ //lose conditions
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Game Over! Total winnings: $%d",_totalCash] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Play Again", nil]; //display total winnings
        [alert show];
        _totalCash = 100; //reset totals
        _roundNumber = 0;
        _betAmount = 50;
        _bet.text = [NSString stringWithFormat:@"Bet: $%d",_betAmount];
        [_plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _plusButton.enabled = YES;
        [_minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _minusButton.enabled = YES;
    }
    else if(_roundNumber<5){ //display round number and keep going if they haven't lost all of their money
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Round %d Over",_roundNumber] message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Next Round", nil];
        [alert show];
    }
    
    _roundNumber++; //increment round number
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_soundEffects playShuffleSound];
    _round.text = [NSString stringWithFormat:@"Round: %d",_roundNumber]; //update round number
    _cash.text = [NSString stringWithFormat:@"Cash: $%d",_totalCash]; //update total cash
    [self restartGame];
}

- (void)restartGame{
    [_gameModel dealNewHand];
    PlayingCard *card;
    
    card = [_gameModel drawPlayerCard];
    card.isFaceUp = YES;
    card = [_gameModel drawDealerCard];
    card.isFaceUp = YES;
    
    card = [_gameModel drawPlayerCard];
    card.isFaceUp = YES;
    
    [_gameModel drawDealerCard];
    
    [self updateView];
    
    self.standButton.enabled = self.hitButton.enabled = YES;
}

- (void)updateView{
    PlayingCard *dealerCard;
    PlayingCard *playerCard;
    UIImageView *dealerCardView;
    UIImageView *playerCardView;
    
    for(int i = 0; i<kNUM_CARDS; i++){
        dealerCardView = _dealerCardViews[i];
        playerCardView = _playerCardViews[i];
        
        dealerCard = [_gameModel dealerCardAtIndex:i];
        playerCard = [_gameModel playerCardAtIndex:i];
        
        dealerCardView.hidden = (dealerCard == nil);
        playerCardView.hidden = (playerCard == nil);
        
        if(dealerCard && dealerCard.isFaceUp){
            dealerCardView.image = [dealerCard getCardImage];
        }
        else{
            dealerCardView.image = [UIImage imageNamed:kCARD_BACK_IMAGE];
        }
        if(playerCard && playerCard.isFaceUp){
            playerCardView.image = [playerCard getCardImage];
        }
        else{
            playerCardView.image = [UIImage imageNamed:kCARD_BACK_IMAGE];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillLayoutSubviews{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLayoutSubviews{
    NSLog(@"%s", __FUNCTION__);
}

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}*/

@end
