class_name Dice

# Etap 1 uses only the Basic Dice (GDD_DICE). Other dice come later.
const BASIC: Array[int] = [1, 2, 3, 4, 5, 6, 7, 8]


static func roll(faces: Array[int]) -> int:
    return faces[randi() % faces.size()]
