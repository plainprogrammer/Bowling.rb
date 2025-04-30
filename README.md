# Bowling Score Calculator

The goal of this exercise is to build a command line program to calculate the
score for a game of bowling. The program is intended to be interactive, asking
the user for each roll for each frame of the game. The program should provide
a running score after each frame, and a final score at the end of the game
before exiting.

## Structure

The following folders have been provided to help you get started:
- `lib`: This folder contains the main code for the program. You will need to
  implement the logic for calculating the score and managing the game state.
- `spec`: This folder contains the tests for the program. You will need to
  write tests to ensure that your implementation is correct.
- `bin`: This folder contains the executable file for the program. You will
  need to implement the command line interface for the program.

## Scoring

Scoring a game of bowling requires more than just simple addition. Certain
rolls can not be scored until one or more subsequent rolls have been made. The
following rules apply:

- A strike is when all ten pins are knocked down on the first roll of a frame.
  The score for that frame is 10 plus the total of the next two rolls.
- A spare is when all ten pins have been knocked down following the second roll
  of a frame. The score for that frame is 10 plus the score of the next roll.
- If neither a strike nor a spare is made, the score for that frame is the
  total number of pins knocked down in that frame.

A frame ends after two rolls, unless a strike is made. The game consists of 10
frames.

The tenth frame is a special case. If the player rolls a strike or a spare in
the tenth frame, they are allowed a third roll within the tenth frame. The
score for the tenth frame is the total of the three rolls.

The maximum score for a game of bowling is 300, which is achieved by rolling 12
strikes in a row.

## Additional Requirements
- The program should be able to handle a full game of bowling, including
  strikes, spares, and open frames.
- The program should raise an error and exit if the user tries to enter
  invalid input (e.g., a negative number of pins knocked down, or more than 10
  pins knocked down in a single roll).
- The program should be able to handle edge cases, such as a game with all
  strikes or all spares.
