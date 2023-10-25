class Mastermind
  NUMBERS = (1..6).to_a

  def initialize
    @round = 1
    @user = String.new
    @secret = Array.new
    @guesses = Array.new
    @feedbacks = Array.new
  end

  def play
    choose_role
    set_secret
    guess_secret
  end

  private

  def choose_role
    game_explanation = "Each round, feedback will be given:\n" +
      "'o' = correct number, correct position\n" +
      "'x' = correct number, wrong position\n" +
      "The code will be a 4-digit number ranging from 1 to 6, e.g., 1234.\n" + 
      "Good luck!\n" +
      "Press Enter to start.."

    loop do
      puts "Welcome to Mastermind!\n" +
        "Choose your role:\n" +
        "Enter 'b' to choose Codebreaker\n" +
        "Enter 'm' to choose Codemaker\n" +
    
      @user = gets.chomp.downcase
    
      if @user == "b"
        puts "You are now the Codebreaker!\n" +
          "You must guess the code within 12 rounds.\n" +
          "#{game_explanation}"
        break
      elsif @user == "m"
        puts "You are now the Codemaker!\n" +
          "You must set a code for the Codebreaker to guess within 12 rounds." +
          "#{game_explanation}"
        break
      else 
        puts "Invalid choice. Please choose again."
      end
    end

    gets
  end
  
  def set_secret
    if @user == "b"
       @secret = NUMBERS.sample(4)
    else 
      loop do
        puts "Enter your secret code"
        code = gets.chomp.chars.map(&:to_i)
    
        if code.size == 4 && code.all? { |num| NUMBERS.include?(num) }
          @secret = code
          puts "The code has been set!\nPress Enter to start.."
          gets
          break
        else
          puts "Invalid code. Please try again."
      end
    end    
  end

  def display
    @guesses.each_with_index do |guess, index|
      puts "Round #{index + 1}: #{@guesses[index].join} #{@feedbacks[index].join}"
    end
  end
    
  def get_feedback(guess)
    secret = @secret.dup
    feedback = Array.new

    guess.each_with_index do |num, index|
      if num == secret[index]
        feedback << "o"
        secret[index] = nil
      end
    end

    guess.each do |num|
      if secret.include?(num)
        feedback << "x"
        secret[secret.index(num)] = nil
      end
    end

    @feedbacks << feedback
  end
    
  def guess_secret
    if @user == "b"
      loop do
        puts "Round #{@round}: Enter your guess?"
        guess = gets.chomp.chars.map(&:to_i)
        if guess.size != 4 || guess.any? { |num| !NUMBERS.include?(num) }
          puts "Invalid guess.\n" +
            "Please try again with a 4-digit number using digits 1 to 6."
        else
          @guesses << guess
          get_feedback(guess)
          display
          if guess == @secret
            puts "You win, you guessed the code in Round: #{@round}!"
            break
          elsif @round == 12
            puts "You lose, the code was #{@secret.join.to_i}."
            break
          else
            @round += 1
          end
        end
      end
      
    else # code for computer to guess
      loop do  # evaluate feedbacks and get guess
        if @feedbacks.empty?
          guess = Array.new(4, 1)
        else
          if 
          
        end
        # get feedback
        @guess << guess
        get_feedback(guess)
        display
        if guess == @secret
          puts "You lose, the code was guessed in Round: #{@round}!"
          break
        elsif @round == 12
          puts "You win, the code was never guessed!"
          break
        else
          @round += 1
        end
      end
    end
  end 
end

Mastermind.new.play