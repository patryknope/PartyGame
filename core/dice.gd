class_name Dice

# Canon dice set (GDD_DICE). In the prototype every player owns all
# dice; acquisition (shop, rewards) comes in later stages.
# The Jackpot Dice's special faces are resolved in GameManager.

const TYPES: Array = [
    {"id": "basic", "name": "Zwykla 1-8", "faces": [1, 2, 3, 4, 5, 6, 7, 8]},
    {"id": "safe", "name": "Pewna 3-6", "faces": [3, 3, 4, 4, 5, 5, 6, 6]},
    {"id": "risk", "name": "Ryzyko 0/10", "faces": [0, 0, 0, 0, 10, 10, 10, 10]},
    {"id": "travel", "name": "Podrozna 2-10", "faces": [2, 2, 4, 4, 8, 8, 10, 10]},
    {"id": "jackpot", "name": "JACKPOT", "faces": [1, 2, 3, 4, 5, 6, 7, 8]},
]


static func roll(faces: Array) -> int:
    return faces[randi() % faces.size()]
