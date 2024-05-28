Paulina & Yael // ptrifon1 & yborger1

October 25, 2023

CS 91S: Games Systems 

E.T. 

Collaboration Statement: I collaborated on this assignment 
                           with my lab partner with assistance from the article you linked :)

1. Explain one good thing about the ET game.
The game has an open world and is focused on exploration which is very different from contemporary games.

2. Explain one bad thing about the ET game.
The collision detection for ET and the holes is such that if any part of the ET sprite overlapped with the hole ET would fall in. 

3. Explain one ugly thing about the ET game.
ET is green in the game. ET is not supposed to be green. This was a very big deal (for the author).

4. Where have we seen Howard Scott Warshaw before?
He designed Yar’s Revenge.

5. What is the "Three Quarters View"?
The “Three Quarters View” is essentially a tilted birds eye view of the playing field. 

6. What was your favorite fix from the hack? Describe how it works in your own words. Explain in detail which 6502 instructions and how they were used.
The Ninja E.T. Easter Egg because it was actually a mistake in the original game, like a proper bug rather than a quirky little joke the developer put in. This was just a bug that people enjoyed so much that they made it an official part of the hack. Basically, if E.T. and Elliott ended the round with three candies each, E.T. would change color (and a bonus 10 candies would be granted the next round). The 6502 instructions for this part mean: load the total candy collected by Ninja E.T. and Elliott and compare the two, followed by the branch if not equal. Then, check that that number is exactly 3. Then we cheer because we got the quirky little easter egg, and add 10 candies (the LDA #$ AA in 6502) for Ninja E.T. and make the energy counter appear empty, with the digits of the counter slowly returning to normal after.
