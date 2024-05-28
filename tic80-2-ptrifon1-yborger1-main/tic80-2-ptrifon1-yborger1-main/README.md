# Assignment 2: TIC-80 Micro Platform Study

**DUE September 15th at 11:59 PM**

You and your partner will conduct a small-scale platform study of
TIC-80. Your platform study should address the following aspects:

  1. What is TIC-80? When and why was TIC-80 created?  Who created it?
  2. How does TIC-80 compare to similar projects?
  3. How does TIC-80 work? (That is a BIG question, but ...)
     - what technologies and languages does it use?
	 - what are the capabilities of the hardware TIC-80 emulates?
	 - **explain the seven segments of the lua project file** (created below by `save platform.lua`)
  4. Write about one TIC-80 game that caught your eye
     (<https://tic80.com/play>); address as
     many of the what/who/when/how/why questions as possible, but
     also:
     - how does it use graphics? (e.g., sprites? text? other graphics primitives?)
     - how does it use sound? (e.g, what kind and for what purpose?)
     - how do the controls work?
     - what is your favorite thing about the game?
               
  5. **[mini-make/hack]** Create something of your own using
      TIC-80. You can modify
      [`10-PRINT`](https://tic80.com/play?cart=1083) or
      [`SNAKE`](https://github.com/nesbox/TIC-80/wiki/Snake-Clone-tutorial),
      or create something new from scratch. Think weird. But also
      think small---this is a one-week lab.  Reflect on what you were
      trying to do with your creation and how much you were able to
      achieve.	  
      - **Use `F8` to grab a screenshot and `F9` for a video (includes these in your report).**

## Learning Objectives

- Explore TIC-80
- Get to know the TIC-80 [docs](https://github.com/nesbox/TIC-80/wiki) & [tutorials](https://github.com/nesbox/TIC-80/wiki/tutorials)
- Think and write critically about gaming platforms

## Deliverable

Submit your platform study on GitHub as a
[markdown](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
document named `README.md`. It does not have to be very long, but
should be written in paragraphs, not as a bulleted list of responses
to the questions of interest above. Be sure to cite where you found
your information. You should also include your TIC-80 creation as a
collection of HTML files in the github project.

```console
unix:~$ cd tic80-2
unix:~$ tic80 --fs .
tic-80:~$ save platform.lua
tic-80:~$ export html platform.zip
unix:~$ unzip platform.zip -d game
```
