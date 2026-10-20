clc; % keep this line of code => must use for full credit

disp('Welcome to Group 9s Casino! Ready for some BlackJack?'); % welcome message, idk thought it was funny

playerCount = input('How many players came to lose money today? '); % ask how many players are playing
disp(['Welcome ' num2str(playerCount) ' players!']) % confirm the number of players

[cardRank, cardSuit, cardVals] = cardCreation(); % creates the card ranks, suits, and values
[deck, deckVals] = shuffleDeck(cardRank, cardSuit, cardVals); % builds and shuffle the deck

% disp(deck) => just for testing to make sure for loop works

playerHands = strings(playerCount, 2); % deals two cards to each player
playerHandVals = zeros(playerCount, 2); % stores the matching values for each player's cards

for playerIndex = 1:playerCount
    playerHands(playerIndex, :) = deck(1:2).'; % deal the two cards to this player
    playerHandVals(playerIndex, :) = deckVals(1:2).'; % store the matching card values
    deck(1:2) = []; % remove the dealt cards from the deck so we dont have repeats
    deckVals(1:2) = []; % remove the matching values from the value list
end

disp("Player hands:") % label the player hand display
disp(playerHands) % show all player hands

%% Dealer rules
dealerHand = strings(1, 2); % holds the dealer's cards
dealerHandVals = zeros(1, 2); % holds the dealer's card values

dealerHand(1, :) = deck(1:2).'; % deals two cards to the dealer
dealerHandVals(1, :) = deckVals(1:2).'; % stores the dealer values
deck(1:2) = []; % remove the dealer's cards from the deck
deckVals(1:2) = []; % remove the dealer's values from the value list

dealerTotal = sum(dealerHandVals); % compute the dealer's starting total

while dealerTotal <= 16 && ~isempty(deck) % dealer hits until the total is 17 or more
    dealerHand = [dealerHand deck(1)]; % add the next card to the dealer's hand
    dealerHandVals = [dealerHandVals deckVals(1)]; % add the matching value
    deck(1) = []; % remove the card from the deck
    deckVals(1) = []; % remove the matching value from the value list
    dealerTotal = sum(dealerHandVals); % recompute the dealer total
end

disp("Dealer hand:") % label the dealer hand display
disp(dealerHand) % show the dealer's hand

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

%Function for dealer rules

%Function for Hit/Stand

