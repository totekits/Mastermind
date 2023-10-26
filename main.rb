class Mastermind
  def initialize
    @round = 1
    @user_is_codebreaker = false
    @secret = Array.new
    @guesses = Array.new
    @feedbacks = Array.new
    @combos = (1..6).to_a.repeated_permutation(4).to_a
    @combo = Array.new
    @winner = false
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
      "Enter to start.."
    
    loop do
      puts "Welcome to Mastermind!\n" +
        "Choose your role:\n" +
        "Enter 'b' to choose Codebreaker\n" +
        "Enter 'm' to choose Codemaker\n"
      
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
  
  def set_secret
    if @user_is_codebreaker == true
      @secret = Array.new(4) { rand(1..6) }
      puts "The secret code has been set!\nEnter to continue.."
      gets
    else 
      loop do
        puts "Enter your secret code"
        secret = gets.chomp.chars.map(&:to_i)
    
        if secret.size == 4 && secret.all? { |num| (1..6).include?(num) }
          @secret = secret
          puts "The secret code has been set!\nEnter to continue.."
          gets
          break
        else
          puts "Invalid code.\n" +
            "Please try again with a 4-digit number using digits 1 to 6."
        end
      end
    end
  end

  def display
    @guesses.each_with_index do |guess, index|
      if index < 9
        puts "Round #{index + 1}:  #{@guesses[index].join} #{@feedbacks[index].join}"
      else 
        puts "Round #{index + 1}: #{@guesses[index].join} #{@feedbacks[index].join}"
      end
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

  def find_combo
    if @feedbacks.last.empty? == true
      @combos.reject! { |combo| combo.include?((@guesses.last)[0])}
    else
      @combos.delete(@guesses.last)
      (@feedbacks.last.size).times do
        @combo << ((@guesses.last[0]))
      end
      new_guess = Array.new
      4.times do 
        new_guess << ((@guesses.last[0]) + 1)
      end
      @combos.unshift(new_guess)
    end
  end
  
  def find_positions
    if @feedbacks.last == %w[x x x x]
      @combos.delete(@guesses.last)
      @combos.reject! do |combo|
        combo.each_with_index.any? { |num, index| num == (@guesses.last)[index] }
      end
    elsif @feedbacks.last == %w[o x x x]
      @combos.delete(@guesses.last)
    elsif @feedbacks.last == %w[o o x x]
      @combos.delete(@guesses.last)
      new_guess = Array.new
        new_guess << (@guesses.last)[0]
        new_guess << (@guesses.last)[1]
        new_guess << (@guesses.last)[3]
        new_guess << (@guesses.last)[2]
        @combos.unshift(new_guess)
    else
      @combos.reject! { |combo| combo.include?((@guesses.last)[0])}
    end
  end
  
  def check_win
    if @user_is_codebreaker == true && @guesses.last == @secret
        puts "You win!"
        @winner = true
    elsif @user_is_codebreaker == true && @round == 12 
        puts "You lose!"
        @winner = true
    elsif @user_is_codebreaker == false && @guesses.last == @secret
        puts "You lose!"
        @winner = true
    elsif @user_is_codebreaker == false && @round == 12
        puts "You win!"
        @winner = true
    end
  end

  def guess_secret
    if @user_is_codebreaker == true
      loop do
        puts "Round #{@round}: Enter your guess.."
        guess = gets.chomp.chars.map(&:to_i)
        if guess.size == 4 && guess.all? { |num| (1..6).include?(num) }
          @guesses << guess
          get_feedback(guess)
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
    else 
      loop do 
        guess = @combos.first
        @guesses << guess
        get_feedback(guess)
        if @combo.size < 4
          find_combo
        else  
          find_positions
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
end

Mastermind.new.play