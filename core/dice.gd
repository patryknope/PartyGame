class_name Dice

# Etap 1 dice set (GDD_DICE): every player owns these three.
# Acquisition (shop, rewards) comes in later stages.

const TYPES: Array = [
    {"id": "basic", "name": "Zwykla (1-8)", "faces": [1, 2, 3, 4, 5, 6, 7, 8]},
    {"id": "safe", "name": "Pewna (3-6)", "faces": [3, 3, 4, 4, 5, 5, 6, 6]},
    {"id": "risk", "name": "Ryzyko (0/10)", "faces": [0, 0, 0, 0, 10, 10, 10, 10]},
]


static func roll(faces: Array) -> int:
    return faces[randi() % faces.size()]
