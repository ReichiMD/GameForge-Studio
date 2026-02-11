# Starter-Kit für neue Spieler
# Gibt Basis-Starter beim ersten Spawn

# Prüfe ob Spieler das Kit schon bekommen hat
execute as @a[tag=!starter_kit_given] run give @s {{PROJECT_NAME}}:base_starter 1
execute as @a[tag=!starter_kit_given] run tag @s add starter_kit_given
