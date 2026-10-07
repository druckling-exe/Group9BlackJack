clc; %keep this line of code => must use for full credit

disp('Welcome to Group 9s Casino! Ready for some BlackJack?'); %Simple Welcome message

playerCount = input('How many players came to lose money today? ', 's'); %call for number of players
disp(['Welcome ' playerCount ' players!']) %response for number of players

cardRank = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]; %details the possible rank of cards
cardSuit = ["Heart", "Spade", "Diamond", "Club"]; %details the possible suit of cards

deck = strings(52,1); %assigns an Array to hold 52 possible cards

for i = 1:52 %forloop using i
    rankIdx = mod(i - 1, numel(cardRank)) + 1;
    suitIdx = floor((i - 1) / numel(cardRank)) + 1; %assigns each number in the array by working through cardRank and the when at end swithces suit

    deck(i) = cardRank(rankIdx) + " of " + cardSuit(suitIdx); %assigns each slot in array the proper card
end

% disp(deck) => just for testing to make sure for loop works

deck = deck(randperm(numel(deck))); %randomizes the deck
