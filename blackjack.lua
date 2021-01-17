math.randomseed(os.time())
cards_in_deck = 52

-- refills deck returns 2D array of the full deck
function shuffleDeck()
  return {{1, "Spade"}, {2, "Spade"}, {3, "Spade"}, {4, "Spade"}, {5, "Spade"}, {6, "Spade"}, {7, "Spade"}, {8, "Spade"}, {9, "Spade"}, {10, "Spade"}, {11, "Spade"}, {12, "Spade"}, {13, "Spade"},
          {1, "Club"}, {2, "Club"}, {3, "Club"}, {4, "Club"}, {5, "Club"}, {6, "Club"}, {7, "Club"}, {8, "Club"}, {9, "Club"}, {10, "Club"}, {11, "Club"}, {12, "Club"}, {13, "Club"},
          {1, "Heart"}, {2, "Heart"}, {3, "Heart"}, {4, "Heart"}, {5, "Heart"}, {6, "Heart"}, {7, "Heart"}, {8, "Heart"}, {9, "Heart"}, {10, "Heart"}, {11, "Heart"}, {12, "Heart"}, {13, "Heart"},
          {1, "Diamond"}, {2, "Diamond"}, {3, "Diamond"}, {4, "Diamond"}, {5, "Diamond"}, {6, "Diamond"}, {7, "Diamond"}, {8, "Diamond"}, {9, "Diamond"}, {10, "Diamond"}, {11, "Diamond"}, {12, "Diamond"}, {13, "Diamond"}}
end

-- draws a random card fomr deck and removes it from the array ( returns a 2d array with the face (1-13) and suit (string))
function drawCard()
  math.randomseed(math.random(99999999))
  local card_id = math.random(1, cards_in_deck)
  drawn = deck[card_id]
  table.remove(deck, card_id)
  cards_in_deck = cards_in_deck - 1
  return drawn
end

-- test if a hand is bust, if so return true
function isHandBust(hand)
  total = 0
  for i, card in pairs(hand) do
    total = total + math.min(card[1], 10)
  end
  if (total > 21) then
    return true
  end
  return false
end

-- for debug (unused)
function printDeck(deck)
  for i, card in pairs(deck) do
    print(card[1] .. ", " .. card[2])
  end
end

-- print card value input array with 2 values (int, string)
function printCard(card)
  print(card[1] .. " of " .. card[2] .. "s")
end

deck = shuffleDeck()

dealer_hand = {}
your_hand = {}

table.insert (your_hand, drawCard())
table.insert (dealer_hand, drawCard())
table.insert (your_hand, drawCard())
table.insert (dealer_hand, drawCard())

if (((your_hand[1][1] == 1) and (your_hand[2][1] == 10)) or ((your_hand[1][1] == 10) and (your_hand[2][1] == 1))) then
  print("hi")
end

if (((dealer_hand[1][1] == 1) and (dealer_hand[2][1] == 10)) or ((dealer_hand[1][1] == 10) and (dealer_hand[2][1] == 1))) then
  print("hii")
end

print("Dealers top card:")
printCard(dealer_hand[2])
print("Your cards:")
printCard(your_hand[1])
printCard(your_hand[2])

state = true
while(state) do
  input = io.read()
  if (input == "hit") then
    table.insert (your_hand, drawCard())
    if (isHandBust(your_hand)) then
      state = false
    end
  elseif(input == "stand") then
    state = false
  end
end

print()
printDeck(your_hand)

local component = require("component")
local gpu = component.gpu
gpu.setResolution(100, 50)
gpu.setBackground(0x999900)
gpu.fill(1, 1, 100, 50, " ")
