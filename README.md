# Mastermind
[This project](https://www.theodinproject.com/lessons/ruby-mastermind) is from the Odin Project's Ruby curriculum. 
## Assignment
1. **Game Objective**: Develop a command-line Mastermind game in which you have 12 turns to decipher the secret code. The game starts with you attempting to guess the computer's randomly generated code.
2. **Player's Choice**: Enhance your code to allow the human player to choose whether they wish to create the secret code or be the guesser.
## Game Rules
1. **Secret Code**: The Codemaker (computer or human) generates a secret code composed of 4-digit numbers, ranging from 1 to 6.
2. **Codebreaker's Challenge**: The Codebreaker has 12 rounds to guess the secret code.
3. **Feedback System**: After each round, the Codebreaker will receive feedback in the form of symbols:
  - 'o': A correct number in the correct position.
  - 'x': A correct number in the wrong position.
## Steps
1. Create Mastermind class to host the game. 
2. Define initialize method with necessary instance variables.
3. Define play method to run the game with necessary methods in order. 
4. Privatize the rest of the methods.
4. Define choose_role method to let user choose their role to play the game.
5. Define codebreaker method to run if player choose to play as codebreaker.
6. Define codemaker method to run if player choose to play as codemaker.
7. Define other necessary methods: get_feedback, display, check_win, display and set_secret.
## Human-like algorithm
I decided not to implement well-known algorithms like Knuth's for the computer to break the code because that would be cheating - human will have no chance to win as a codemaker. Instead, I implemented my own human-like strategy. First, it will try to identify the correct 4 digits, then it will try to guess the correct positions of each digits. Like this, the computer will have the possibility to win or lose the game. Here's how it works:
### Identify correct digits
- Round 1: start with 1111, if feedback has n number of o, add n number of o to an array
- Round 2: guess with 2222, repeat until the array has four numbers, that would be the correct numbers
### Find correct positions
- start the next round with numbers in the array,
  - if feedback is xxxx or oxxx, rotate the guess and use that new combination to guess in the next round
  - if feedback is ooxx, and the last two digits aren't the same, swap the third and forth numbers in the guess and use the new combination to guess in the next round
  - if feedback is ooxx, but the last two digits are the same, rotate instead of swap
- repeat
## New things I learned
- #gets
- \n
- #sample
- #dup
- #clone
- Range class
- #match?
- #repeated_permutation
- #index
- #rand
- #rotate ***super cool!***
