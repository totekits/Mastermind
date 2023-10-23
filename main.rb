class Mastermind
  ALPHABETS = %w[a b c d e f]

  def initialize
    @round = 1
    @secret = []
    @guess = []
    @feedback = []
    @winner = ""
  end

  def play
    greet
    set_secret
    play_rounds
  end

  private

  def greet
    puts "
    Welcome to Mastermind!\n
    You have 12 rounds to guess the secret code\n
    Each round you will be given feedback on your guess\n
    o pegs indicate a correct color in the correct position\n
    x pegs indicate a correct color in the wrong position\n
    n pegs indicate a wrong color in the wrong position\n
    To guess the secret code, enter 4 alphabets (a, b, c, d, e, f) with no spaces\n
    Good luck!\n
    Press enter to start
    "
    gets
  end

  def set_secret
    @secret = ALPHABETS.sample(4)
  end

  def guess_valid?(guess)
    guess.size == 4 && guess.all? { |letter| ALPHABETS.include?(letter) }
  end  

  def display
    @guess.each_with_index do |guess, index|
        puts "Round #{index + 1}: #{@guess[index].join} #{@feedback[index].join}\n"
    end
  end

  def end_game
    if @winner == "codebreaker"
      puts "Congratulations! You guessed the secret code in #{@round} rounds!"
    elsif @winner == "codemaker"
      puts "You lost! The secret code was #{@secret.join}"
    end
  end
  
  def evaluate_guess(guess)
    feedback = []

    guess.each_with_index do |letter, index|
      if letter == @secret[index]
        feedback << "o"
      end
    end

    guess.each_with_index do |letter, index|
      if letter != @secret[index] && @secret.include?(letter)
        feedback << "x"
      end
    end

    (4 - feedback.size).times { feedback << "n" }

    @feedback << feedback
  end

  def play_rounds
    puts "Round #{@round}: enter 4 alphabets"
    guess = gets.chomp.downcase.split('')
    if !guess_valid?(guess)
      puts "Invalid guess. Try again."
      play_rounds
    else
      @guess << guess
      evaluate_guess(guess)
    end
    
    display

    if @secret == @guess.last
      @winner = "codebreaker"
      end_game
    elsif @round == 12
      @winner = "codemaker"
      end_game
    else
      @round += 1
      play_rounds
    end
  end
end

Mastermind.new.play