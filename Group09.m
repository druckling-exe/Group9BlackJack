% Group09
clear;
clc;
% clear the command window first

disp('Welcome to Group 9''s Casino! Ready for some BlackJack?'); % welcome message

playerCount = input('How many players came to loose money today? '); % ask how many players there are
disp(['Welcome ' num2str(playerCount) ' players!']) % confirm the player count

[cardRank, cardSuit, cardVals] = cardCreation(); % create the card lists
[deck, deckVals] = shuffleDeck(cardRank, cardSuit, cardVals); % build and shuffle the deck

[playerHands, playerHandVals, dealerHand, dealerHandVals, deck, deckVals] = dealDeck(deck, deckVals, playerCount); % deal the cards

disp("Player hands:") % show the player hands label
disp(playerHands) % display all player hands

disp("Dealer hand:") % show the dealer hand label
disp(dealerHand) % display the dealer hand
disp(['Dealer total: ' num2str(calculateScore(dealerHandVals))]) % show dealer total

finalScores = zeros(playerCount, 1); % store each player's score

% let each player take a turn
for playerIdx = 1:playerCount
    currentHand = playerHands(playerIdx, :); % get this player's current hand
    currentVals = playerHandVals(playerIdx, :); % get this player's card values
    [currentHand, currentVals, deck, deckVals] = playPlayerHand(currentHand, currentVals, deck, deckVals, playerIdx, dealerHandVals); % let the player hit or stand
    playerHands(playerIdx, 1:numel(currentHand)) = currentHand; % store updated hand
    playerHandVals(playerIdx, 1:numel(currentVals)) = currentVals; % store updated values
    finalScores(playerIdx) = calculateScore(currentVals); % save this player's final score
end

% dealer turn happens after all players finish
[dealerHand, dealerHandVals, deck, deckVals] = playDealerHand(dealerHand, dealerHandVals, deck, deckVals);
dealerScore = calculateScore(dealerHandVals); % calculate the dealer's score

disp("Final player scores:") % show the final player scores label
disp(finalScores) % display the player scores
disp("Dealer final hand:") % show dealer hand label
disp(dealerHand) % display dealer hand
disp(['Dealer score: ' num2str(dealerScore)]) % display the dealer score

% Ending messages
if any(finalScores > 21)
    disp('Bust! You lose') % Bust losing message
elseif all(finalScores <= 21) && all(finalScores > dealerScore)
    disp('You win!') % Winning message 
elseif finalScores < 17
    disp('You lose') % Losing message
elseif finalScores == dealerScore
    disp('Push! Its a tie!')
end

%%%%%% Function Graveyard %%%%%%


%Function to create the deck of cards
function [cardRank, cardSuit, cardVals] = cardCreation() % make the rank, suit, and value arrays
cardRank = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"];
cardSuit = ["Hearts", "Spades", "Diamonds", "Clubs"];
cardVals = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10];
end


%Function to shuffle the deck of cards
function [deck, deckVals] = shuffleDeck(cardRank, cardSuit, cardVals) % build and shuffle the deck
deck = strings(52, 1); % preallocate the deck names
deckVals = zeros(52, 1); % preallocate the deck values

k = 1; % deck position counter
for suitIdx = 1:numel(cardSuit) % loop through each suit
    for rankIdx = 1:numel(cardRank) % loop through each rank
        deck(k) = cardRank(rankIdx) + " of " + cardSuit(suitIdx); % build the card name
        deckVals(k) = cardVals(rankIdx); % store the matching value
        k = k + 1; % move to the next card
    end
end

perm = randperm(numel(deck)); % randomize the deck order
deck = deck(perm); % shuffle the card names
deckVals = deckVals(perm); % shuffle the values the same way
end


%Function to deal the cards
function [playerHands, playerHandVals, dealerHand, dealerHandVals, deck, deckVals] = dealDeck(deck, deckVals, playerCount) % deal cards to the players and dealer
playerHands = strings(playerCount, 2); % store each player's first two cards
playerHandVals = zeros(playerCount, 2); % store each player's first two values

for playerIndex = 1:playerCount % deal to each player
    playerHands(playerIndex, :) = deck(1:2).';
    playerHandVals(playerIndex, :) = deckVals(1:2).';
    deck(1:2) = []; % remove dealt cards
    deckVals(1:2) = []; % remove dealt values
end

dealerHand = deck(1:2).'; % deal two cards to the dealer
dealerHandVals = deckVals(1:2).'; % store the dealer values
deck(1:2) = []; % remove those cards from the deck
deckVals(1:2) = []; % remove those values from the deck values
end


%Function to hit/stand with the cards (Turns)
function [hand, handVals, deck, deckVals] = playPlayerHand(hand, handVals, deck, deckVals, playerIdx, dealerHandVals)
if playerIdx == 1 % first player is the human
    disp('Player 1 Turn');
    playing = true;

    while playing && ~isempty(deck)
        currentScore = calculateScore(handVals); % calculate the current score
        dealerScore = calculateScore(dealerHandVals); % calculate dealer total
        disp('Your current hand is:'); % show the current hand
        disp(hand);
        disp(['Current Score: ' num2str(currentScore)]);
        disp(['Dealer Total: ' num2str(dealerScore)]);

        if currentScore > 21
            disp('Bust! You went over 21.')
            playing = false;
        else
            choiceValid = false;
            while ~choiceValid
                choice = lower(strtrim(input('Would you like to HIT (1) or STAND (2)? ','s'))); % read text input

                if strcmp(choice, '1') || strcmp(choice, 'hit')
                    hand = [hand, deck(1)]; % draw a card
                    handVals = [handVals, deckVals(1)]; % add the matching value
                    deck(1) = []; % remove the card from the deck
                    deckVals(1) = []; % remove the matching value
                    choiceValid = true;
                elseif strcmp(choice, '2') || strcmp(choice, 'stand')
                    playing = false; % stand ends the turn
                    choiceValid = true;
                else
                    disp('Please enter 1/hit or 2/stand.');
                end
            end
        end
    end

    disp('Player 1 finished with hand:');
    disp(hand);
    disp(['Player 1 final score: ' num2str(calculateScore(handVals))]);
else
    disp(['Player ', num2str(playerIdx), ' Turn (Dealer Bot)']); % bot turn message
    score = calculateScore(handVals);

    while score < 17 && ~isempty(deck) % bot keeps hitting until 17 or higher
        hand = [hand, deck(1)];
        handVals = [handVals, deckVals(1)];
        deck(1) = [];
        deckVals(1) = [];
        score = calculateScore(handVals);
    end

    disp(['Player ', num2str(playerIdx), ' finished with score: ', num2str(score)]);
end
end


%Function to let the dealer hit after the players finish
function [hand, handVals, deck, deckVals] = playDealerHand(hand, handVals, deck, deckVals)
disp('Dealer Turn');
score = calculateScore(handVals);

while score < 17 && ~isempty(deck)
    hand = [hand, deck(1)];
    handVals = [handVals, deckVals(1)];
    deck(1) = [];
    deckVals(1) = [];
    score = calculateScore(handVals);
end

disp('Dealer finished with hand:');
disp(hand);
end



%Function to calculate the hand score
function score = calculateScore(handVals) % calculate the hand score, counting aces as 1 if needed
score = sum(handVals);

while score > 21 && any(handVals == 11)
    handVals(handVals == 11) = 1;
    score = sum(handVals);
end
end
