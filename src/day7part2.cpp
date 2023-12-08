#include <initializer_list>
#include <iostream>
#include <algorithm>
#include <stdexcept>
#include <string>
#include <vector>
#include <array>
#include <map>

using namespace std;

enum class Card : char
{
    A, K, Q, T, N9, N8, N7, N6, N5, N4, N3, N2, J
};

enum class Kind : char
{
    FiveOfAKind, FourOfAKind, FullHouse, ThreeOfAKind, TwoPair, OnePair, HighCard
};

struct Hand
{
    array<Card, 5> cards;
    Kind kind;

    Hand(const string& c)
    {
        for (int i = 0; i < 5; i++) {
            switch (c[i]) {
                case 'A': cards[i] = Card::A;  break;
                case 'K': cards[i] = Card::K;  break;
                case 'Q': cards[i] = Card::Q;  break;
                case 'J': cards[i] = Card::J;  break;
                case 'T': cards[i] = Card::T;  break;
                case '9': cards[i] = Card::N9; break;
                case '8': cards[i] = Card::N8; break;
                case '7': cards[i] = Card::N7; break;
                case '6': cards[i] = Card::N6; break;
                case '5': cards[i] = Card::N5; break;
                case '4': cards[i] = Card::N4; break;
                case '3': cards[i] = Card::N3; break;
                case '2': cards[i] = Card::N2; break;
                default: throw invalid_argument(string(1, c[i]));
            }
        }
        kind = get_kind();
    }

    Kind get_kind()
    {
        map<Card, size_t> counts_map;
        for (const Card cards : cards)
            counts_map[cards]++;

        auto jokers = counts_map[Card::J];
        counts_map.erase(Card::J);

        vector<size_t> counts;
        for (const auto& [card, count] : counts_map)
            counts.push_back(count);
        sort(counts.begin(), counts.end(), greater<>());
        if (counts.size() == 0) counts.push_back(0);
        counts.push_back(jokers);

        auto eq = [counts](initializer_list<size_t> c) {
            return counts == vector<size_t>(c);
        };

        if (eq({5, 0}) || eq({4, 1}) || eq({3, 2}) || eq({2, 3}) || eq({1, 4}) || eq({0, 5}))
            return Kind::FiveOfAKind;
        if (eq({4, 1, 0}) || eq({3, 1, 1}) || eq({2, 1, 2}) || eq({1, 1, 3}))
            return Kind::FourOfAKind;
        if (eq({3, 2, 0}) || eq({2, 2, 1}))
            return Kind::FullHouse;
        if (eq({3, 1, 1, 0}) || eq({2, 1, 1, 1}) || eq({1, 1, 1, 2}))
            return Kind::ThreeOfAKind;
        if (eq({2, 2, 1, 0}))
            return Kind::TwoPair;
        if (eq({2, 1, 1, 1, 0}) || eq({1, 1, 1, 1, 1}))
            return Kind::OnePair;

        return Kind::HighCard;
    }

    bool operator<(const Hand& other) const
    {
        // logic is inverted because enum members
        // are listed strongest to weakest
        if (kind > other.kind)
            return true;
        if (kind < other.kind)
            return false;

        for (int i = 0; i < 5; i++)
        {
            if (cards[i] > other.cards[i])
                return true;
            if (cards[i] < other.cards[i])
                return false;
        }

        return false;
    }

};

struct HandBid
{
    Hand hand;
    size_t bid;

    HandBid(const string& h, const string& b)
        : hand(h), bid(stoi(b)) {}

    bool operator<(const HandBid& other) const
    {
        return hand < other.hand;
    }
};

vector<HandBid> hands;

int main()
{
    string hand, bid;
    while (cin >> hand >> bid)
        hands.emplace_back(hand, bid);

    sort(hands.begin(), hands.end());

    size_t sum = 0;
    for (size_t i = 0; i < hands.size(); i++) {
        sum += hands[i].bid * (i + 1);
    }

    cout << sum << '\n';
}
