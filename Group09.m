clc; % keep this line of code => must use for full credit

disp('Welcome to Group 9s Casino! Ready for some BlackJack?'); % welcome message, idk thought it was funny

playerCount = input('How many players came to lose money today? '); % ask how many players are playing
disp(['Welcome ' num2str(playerCount) ' players!']) % confirm the number of players

[cardRank, cardSuit, cardVals] = cardCreation(); % creates the card ranks, suits, and values
[deck, deckVals] = shuffleDeck(cardRank, cardSuit, cardVals); % builds and shuffle the deck

% disp(deck) => just for testing to make sure for loop works

[playerHands, playerHandVals, dealerHand, dealerHandVals, deck, deckVals] = dealDeck(deck, deckVals, playerCount); % deals cards to players and dealer

disp("Player hands:") % label the player hand display
disp(playerHands) % show all player hands

disp("Dealer hand:") % label the dealer hand display
disp(dealerHand) % show the dealer's hand

finalScores = zeros(playerCount, 1); % i hope we are allowed to do this, if not, omit it --> it just makes a matrix filled with zeroes so that the player's final scores can be stored 

% basis for the turn system 
for playerIdx = 1:playerCount % mechanic for when player executes their turn 
    currentHand = playerHands(playerIdx, :);
    currentVals = playerHandVals(playerIdx, :); 
    [currentHand, currentVals, deck,deckVals] = playerHand(currentHand,currentVals, deck, deckVals, playerIdx); % calls hit or stand for each player 
    finalScores(playerIdx) = calculateScore(currentVals);
end 

dealerScore = calcualteScore(dealerHandVals); % for calculating dealer's final score with ace 




%%%%% Function Graveyard

%Function that makes deck
function [cardRank, cardSuit, cardVals] = cardCreation() % Creates the card rank, suit, and value arrays
cardRank = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]; % Card ranks
cardSuit = ["Hearts", "Spades", "Diamonds", "Clubs"]; % Card suits
cardVals = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]; % Card values
end

%Function that shuffles deck
function [deck, deckVals] = shuffleDeck(cardRank, cardSuit, cardVals) % Builds and shuffles the deck
deck = strings(52, 1); % Preallocate the deck
deckVals = zeros(52, 1); % Preallocate the deck values

k = 1; % Deck counter
for suitIdx = 1:numel(cardSuit) % Loop through each suit
    for rankIdx = 1:numel(cardRank) % Loop through each rank
        deck(k) = cardRank(rankIdx) + " of " + cardSuit(suitIdx); % Build the card name
        deckVals(k) = cardVals(rankIdx); % Store the matching card value
        k = k + 1; % Move to the next deck position
    end
end

perm = randperm(numel(deck)); % Create a random shuffle order
deck = deck(perm); % Shuffle the card names
deckVals = deckVals(perm); % Shuffle the values the same way
end

%Function that deals deck
%Function that deals deck
function [playerHands, playerHandVals, dealerHand, dealerHandVals, deck, deckVals] = dealDeck(deck, deckVals, playerCount) % Deals cards to players and dealer
playerHands = strings(playerCount, 2); % holds the two cards for each player
playerHandVals = zeros(playerCount, 2); % holds the matching values for each player's cards

for playerIndex = 1:playerCount % loop through each player
    playerHands(playerIndex, :) = deck(1:2).'; % deal the first two cards to this player
    playerHandVals(playerIndex, :) = deckVals(1:2).'; % store the matching card values
    deck(1:2) = []; % remove the dealt cards from the deck so we dont have repeats
    deckVals(1:2) = []; % remove the matching values from the value list
end

dealerHand = strings(1, 2); % holds the dealer's cards
dealerHandVals = zeros(1, 2); % holds the dealer's card values

dealerHand = deck(1:2).'; % deal two cards to the dealer
dealerHandVals = deckVals(1:2).'; % store the dealer values
deck(1:2) = []; % remove the dealer's cards from the deck
deckVals(1:2) = []; % remove the dealer's values from the value list

while sum(dealerHandVals) <= 16 && ~isempty(deck) % dealer hits until the total is 17 or more
    dealerHand = [dealerHand deck(1)]; % add the next card to the dealer's hand
    dealerHandVals = [dealerHandVals deckVals(1)]; % add the matching value
    deck(1) = []; % remove the card from the deck
    deckVals(1) = []; % remove the matching value from the value list
end
end

%Function for dealer rules

%Function for Hit/Stand
function [hand, handVals, deck, deckVals] = playPlayerHand(hand, handVals, deck, deckVals, playerIdx);
if playerIdx ==1 % checks for user/human player or bot 
    disp('Player 1 Turn'); 
    playing = true; 
    while playing  
        currentScore = calculateScore(handVals); % calculate score while playing 
        disp('Your current hand are: '); % displays the player's current hand 
        disp(hand);
        disp(['Current Score :', num2str(currentScore)]);
        if currentScore > 21 % if statement to check if player's score is greater than 21 --> which is the condition for a bust
            disp('Bust! Too bad! You went over 21. Good Luck next time ~')
        end

        choice = input ('Would you like to HIT (1) or STAND (2) ? '); % asks user if they want to hit or stand 
        if choice == 1 % this signifies hit, which means that the top card of the deck array is drawn 
            hand = [hand, deck(1)]; 
            handVals = [handVals, deckVals(1)]; 
            deck(1) = [];  %allows for the drawn card to be removed from the deck 
            deckVals(1) = []; 
        else 
            playing = false; % can be interpreted as stand. it stops the loop and ends the player's/user's turn 
        end 
    end
else 
    disp(['Player ', num2str(playerIdx), ' Turn (Dealer Bot)']); % displays that the bot follows dealer's rules (named dealer bot)
    score = calculateScore(handVals); 
    while score < 17 && ~isempty(deck) %this while statement allows for cards to be drawn (also known as hitting) as long as the cumulative score is under 17
        hand = [hand, deck(1)];
        handVals = [handVals, deckVals(1)];
        deck(1) = []; 
        deckVals(1) = []; 
        score = calculateScore(handVals); 
    end 
    disp(['Player ', num2str(playerIdx), ' finished with score: ', num2str(score)]); % displays the final score of the bot
    end 
end




