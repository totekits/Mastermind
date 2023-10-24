class Mastermind
  NUMBERS = (1..6).to_a

  def initialize
    @user_role = ""
    @round = 1
    @secret = []
    @guess = []
    @feedback = []
    @winner = ""
  end

  def play
    decide_role
    set_secret
    play_rounds
  end

  private

  def decide_role
    feedback_explanation = "
      'o' indicates a correct number in the correct position.\n
      'x' indicates a correct number in the wrong position.\n
      'n' indicate a wrong number in the wrong position.\n
      "
    
    puts "Welcome to Mastermind!\n
      Enter 'cb' to play as a codebreaker, or 'cm' to play as a codemaker."
    
    role = gets.chomp.downcase
    
    if role == "cb"
      puts "You are the codebreaker!\n
        You will have 12 rounds to guess the secret code.\n
        Each round, you will receive feedback on your guess:\n
        #{feedback_explanation}
        To guess the secret code, enter 4 numbers (1-6) with no spaces.\n
        Good luck!\n
        Press Enter to start."
    elsif role == "cm"
      puts "You are the codemaker!\n
        You will have to set the secret code.\n
        The computer will then have 12 rounds to guess the secret code.\n
        Each round, the computer will receive feedback on its guess:\n
        #{feedback_explanation}
        To set the secret code, enter 4 numbers (1-6) with no spaces.\n
        Good luck!\n
        Press Enter to start."
    else 
      puts "Invalid input. Please try again."
      decide_role
    end
    
    @user_role = role
    gets
  end

  def set_secret
    @secret = NUMBERS.sample(4)
  end

  def guess_valid?(guess)
    guess.size == 4 && guess.all? { |num| NUMBERS.include?(num) }
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

    guess.each_with_index do |num, index|
      if num == @secret[index]
        feedback << "o"
      end
    end

    guess.each_with_index do |num, index|
      if num != @secret[index] && @secret.include?(num)
        feedback << "x"
      end
    end

    (4 - feedback.size).times { feedback << "n" }

    @feedback << feedback
  end

  def play_rounds
    puts "Round #{@round}: enter 4 numbers"
    guess = gets.chomp.chars.map(&:to_i)
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