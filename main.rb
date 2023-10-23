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
    evaluate_guess
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

  def display_result
    @guess.each_with_index do |guess, index|
      puts "#{guess.join} | #{@feedback[index].join}\n"
    end
  end

  def end_game
    if @winner == "codebreaker"
      puts "Congratulations! You guessed the secret code in #{@round} rounds!"
    else
      puts "You lost! The secret code was #{@secret.join}"
    end
  end
  
  def evaluate_guess(guess)
    if guess == @secret
      @feedback << ["o", "o", "o", "o"]
      @winner = "codebreaker"
      display_result
      end_game
    else
      
      secret = @secret
      
      secret.each_with_index do |letter, index|
        if letter == guess[index]
          feedback << "o"
          secret = secret - letter
          guess = guess - letter
      end
        
      guess.each do |letter|
        if secret.include?(letter)
          feedback << "x"
          secret = secret - letter
          guess = guess - letter
      end
        
      guess.size.times do
        feedback << "n"
      end   
      display_result
      @round += 1
    end  
  end

  def play_rounds
    puts "Round #{@round} enter 4 alphabets (a, b, c, d, e, f) with no spaces"
    guess = gets.chomp.downcase.split('')
    if !guess_valid?
      puts "Invalid guess. Try again."
      play_rounds
    else
      @guess << guess
      evaluate_guess
    end
    
    if @round < 12
      play_rounds
    else
      end_game
    end
  end
end

Mastermind.new.play