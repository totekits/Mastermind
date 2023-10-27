class Mastermind
  def initialize
    @user_is_codebreaker = false
    @winner = false
    @round = 1
    @secret = []
    @guesses = []
    @feedbacks = []
  end

  def play
    choose_role
    
    if @user_is_codebreaker == true
      codebreaker
    else
      codemaker
    end
  end

  private

  def choose_role
    game_explanation = "Each round, feedback will be given:\n" +
      "'o' = correct number and correct position\n" +
      "'x' = correct number but wrong position\n" +
      "The code will be a 4-digit number ranging from 1 to 6, e.g., 1234.\n" + 
      "Good luck!\n" +
      "Press Enter to start.."
    
    loop do
      puts "Welcome to Mastermind!\n" +
        "Choose your role:\n" +
        "Type 'b' and press Enter to choose Codebreaker\n" +
        "Type 'm' and press Enter to choose Codemaker\n"
      
      choice = gets.chomp
    
      if choice == "b"
        puts "You are now the Codebreaker!\n" +
          "You must guess the code within 12 rounds.\n" +
          "#{game_explanation}"
        @user_is_codebreaker = true
        break
      elsif choice == "m"
        puts "You are now the Codemaker!\n" +
          "You must set a secret code for the Codebreaker to guess within 12 rounds." +
          "#{game_explanation}"
        break
      else 
        puts "Invalid choice. Please choose again."
      end
    end

    gets
  end

  def check_win
    if @user_is_codebreaker == true && @guesses.last == @secret
        puts "You win!\n" + 
          "The secret code is #{@secret.join}"
        @winner = true
    elsif @user_is_codebreaker == true && @round == 12 
        puts "You lose!\n" +
          "The secret code is #{@secret.join}"
        @winner = true
    elsif @user_is_codebreaker == false && @guesses.last == @secret
        puts "You lose!\n" +
          "The secret code #{@secret.join} was guessed in round #{@round}."
        @winner = true
    elsif @user_is_codebreaker == false && @round == 12
        puts "You win!\n" +
          "The secret code #{@secret.join} was never guessed."
        @winner = true
    end
  end
  
  def display
    @guesses.each_with_index do |g, i|
      if i < 9
        puts "Round #{i + 1}:  #{@guesses[i].join} #{@feedbacks[i].join}"
      else 
        puts "Round #{i + 1}: #{@guesses[i].join} #{@feedbacks[i].join}"
      end
    end
  end
  
  def get_feedback
    secret = @secret.dup
    feedback = []

    (@guesses.last).each_with_index do |n, i|
      if n == secret[i]
        feedback << "o"
        secret[i] = nil
      end
    end

    (@guesses.last).each do |n|
      if secret.include?(n)
        feedback << "x"
        secret[secret.index(n)] = nil
      end
    end

    @feedbacks << feedback
  end
  
  def codebreaker
    @secret = Array.new(4) { rand(1..6) }
    
    loop do
      puts "Round #{@round}: Type your guess and press Enter.."
      guess = gets.chomp.chars.map(&:to_i)
      
      if guess.size == 4 && guess.all? { |n| (1..6).include?(n) }
        @guesses << guess
        get_feedback
        display
        check_win
        
        if @winner == true
          break
        end
        
        @round += 1
      else
        puts "Invalid guess.\n" +
          "Please try again with a 4-digit number using digits 1 to 6."
      end
    end
  end

  def set_secret
    loop do
      puts "Type your secret code and press Enter.."
      @secret = gets.chomp.chars.map(&:to_i)

      if @secret.size == 4 && @secret.all? { |n| (1..6).include?(n) }
        puts "The secret code has been set!\nPress Enter to continue.."
        break
      else
        puts "Invalid code.\n" +
          "Please try again with a 4-digit number using digits 1 to 6."
      end
    end

    gets
  end

  def codemaker
    combo = []
    set_secret
    
    loop do
      if @round == 1
        @guesses << Array.new(4, 1)
      elsif @round > 1
        if combo.size < 4
          @guesses << Array.new(4) { @guesses.last.sample + 1 }
        elsif combo.size == 4 && @feedbacks.all? { |f| f.size < 4 }
          @guesses << combo
        elsif combo.size == 4
          if @feedbacks.last == %w[x x x x] || @feedbacks.last == %w[o x x x] ||
            (@feedbacks.last == %w[o o x x] && @guesses.last[2] == @guesses.last[3])
            @guesses << @guesses.last.rotate
          elsif @feedbacks.last == %w[o o x x] && @guesses.last[2] != @guesses.last[3]
            guess = [@guesses.last[0], @guesses.last[1], @guesses.last[3], @guesses.last[2]]
            while @guesses.include?(guess)
              guess = guess.rotate
            end
            @guesses << guess
          end
        end
      end

      get_feedback

      if combo.size < 4 && @feedbacks.last.include?("o")
        @feedbacks.last.each { |n| combo << @guesses.last[0] }
      end
        
      display
      check_win
      
      if @winner == true
        break
      end
      
      @round += 1
      puts "Enter to continue.."
      gets
    end
  end
end

Mastermind.new.play