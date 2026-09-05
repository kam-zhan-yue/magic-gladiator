# Sandworm Boss

Is this going to be fun? I don't know, but the only way to know is to actually build something.

Acts as the first introductory boss to the game, teaching the player about how to use their foundational skills and how to move around the arena. 

I guess I need to decide whether the boss is able to split or it splits automatically.
- If it splits where it is attacked, it makes it feel like the game is responding to the player, which is an advantage of procedural animation
- If it splits automatically, I can control where each piece goes etc.

However, I think it is more fun to make it split where it got hurt, so let's roll with that.

Instead of having phases, let's just have the sandworms alternate between simple attacks.
Just like the first boss of Titan Souls, all it does is move to the player and split

So then, each sandworm is going to have two movement patterns
- Charging: Moving towards the player
- Dwelling: Moving around the arena

## Version 1
- Charging: Charges towards the player
- Dwelling: Movest to a random spot in the arena
- Swaps between each other
