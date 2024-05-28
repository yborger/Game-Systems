# Assignment 4: 6502 & Stella

**DUE October 6th at 11:59 PM**

There are two parts of this lab that should **be completed** before the lab period
(via google form):

1. a few short answer questions;
2. some number representation refresher exercises.

Then there are three hands-on pieces to be done during lab.

1. an open-ended snake game challenge;
2. stella battle-zone hack;
3. getting to know the Atari CLI tools.


## Assembling & Disassembling via the CLI

### Using dasm

Use [`dasm`](https://raw.githubusercontent.com/dasm-assembler/dasm/master/docs/dasm.pdf) to assemble the [10-Print source](http://bogost.com/downloads/10-Print-Atari.zip). And then `stella` to run the binary. I've included the files you'll need, but you can grab them from [github](https://raw.githubusercontent.com/dasm-assembler/dasm/) otherwise.

```
$ dasm 10Print-scrolling.asm -f3 -v5 -oout.bin
$ stella out.bin
```

**NOTE:** You can also use [8bitworkshop](http://8bitworkshop.com/v3.1.0/?=&platform=vcs&file=examples%2Fhello) to assemble the code and
emulate the binary in the browser.

### Using distella

Use [`distella`](https://github.com/johnkharvey/distella) to
disassemble the the binaries provided by Bogost. 

```
$ distella -pas 10Print-scrolling.bin > 10print.s
```

**NOTE:** You can also use `stella` to disassemble, in the prompt type
`saveDis` and save the ROM using `saveROM`.

### Reflection

Write a few sentences on how diassembled code compares with the source
code provided. Do they both run the same way within stella? How are
the two assembly listings different?
**The source-code provided is significantly more readable, especially with comments that label each section. The source code is actually understandable as a human. On the other hand, the disassembled code lacks most comments and is only understandable if you have a solid background in the registers provided. They both have certain overlapping commands but the lack of comments really impacts the difficulty. There are also keywords in the given source-code that make more intuitive sense.**

## Using the Stella Debugger

We will practice using [`stella`](https://stella-emu.github.io/) to
understand (and change) how an Atari 2600 game works.  Follow along
the Battlezone
[tutorial](https://stella-emu.github.io/docs/debugger.html#Howtohack)
and complete the 16 steps. Try using
[trap/break](https://stella-emu.github.io/docs/debugger.html#ConditionalBreaks)
to find where in the game the joystick is polled. For example, you can
find where in the game logic the tank fires by running `trapRead
INPT4`. Once you have completed the tutorial, call me over to show me,
then apply some of the techniques to your own hack project.


## SNAKE

Follow the [6502 tutorial](http://skilldrick.github.io/easy6502/#snake) and modify the snake game in
inventive ways. Some suggestions:

  - change the color of the snake or apple;
  - make the apple move;
  - change the keys used to control the snake;
  - add an additional apple to eat;
  - add a second snake with different controls;
  - some other Pippin Barr style [*snakism*](https://pippinbarr.com/SNAKISMS/).
  
Write about what you attempted, what you accomplished, and include your snake program as a file `snake.s`.

**We attempted to change the color of the apple so it would stop flashing, and we made it hold a solid color. Then we wanted to change the color of the snake, and accidentally made the snake have a slime trail that we then colored as well. As a result, we have a snake-drawing-tool instead. It’s very cool, to be honest. Very nice to draw with. We considered recreating our “ekans” game but we are both quite tired of Snake, if we’re being honest.**
