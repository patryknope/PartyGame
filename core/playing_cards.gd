class_name PlayingCards

# Standard 52-card deck + 5-card poker hand evaluation.
# Suits: 0 spades, 1 hearts, 2 diamonds, 3 clubs.

const HAND_NAMES: Array[String] = [
    "Wysoka karta", "Para", "Dwie pary", "Trojka", "Strit",
    "Kolor", "Full", "Kareta", "POKER!",
]


static func new_deck() -> Array:
    var deck: Array = []
    for suit in 4:
        for rank in range(2, 15):
            deck.append({"rank": rank, "suit": suit})
    deck.shuffle()
    return deck


static func rank_label(rank: int) -> String:
    match rank:
        11: return "J"
        12: return "Q"
        13: return "K"
        14: return "A"
        _: return str(rank)


static func evaluate(hand: Array) -> Dictionary:
    var counts := {}
    var suits := {}
    for card in hand:
        counts[card["rank"]] = counts.get(card["rank"], 0) + 1
        suits[card["suit"]] = suits.get(card["suit"], 0) + 1
    var is_flush := suits.size() == 1
    var ranks: Array = counts.keys()
    ranks.sort()
    var is_straight := false
    var straight_high := 0
    if ranks.size() == 5:
        if int(ranks[4]) - int(ranks[0]) == 4:
            is_straight = true
            straight_high = ranks[4]
        elif ranks == [2, 3, 4, 5, 14]:
            is_straight = true
            straight_high = 5
    var by_count: Array = counts.keys()
    by_count.sort_custom(
        func(a, b): return (counts[a] > counts[b]) if counts[a] != counts[b] else (a > b)
    )
    var max_count: int = counts[by_count[0]]
    var second_count: int = counts[by_count[1]] if by_count.size() > 1 else 0
    var category := 0
    if is_straight and is_flush:
        category = 8
    elif max_count == 4:
        category = 7
    elif max_count == 3 and second_count == 2:
        category = 6
    elif is_flush:
        category = 5
    elif is_straight:
        category = 4
    elif max_count == 3:
        category = 3
    elif max_count == 2 and second_count == 2:
        category = 2
    elif max_count == 2:
        category = 1
    var score: Array = [category]
    if is_straight:
        score.append(straight_high)
    else:
        score.append_array(by_count)
    return {"category": category, "score": score, "name": HAND_NAMES[category]}


static func compare_scores(a: Array, b: Array) -> int:
    for i in mini(a.size(), b.size()):
        if a[i] != b[i]:
            return 1 if a[i] > b[i] else -1
    return 0
