class Mastermind
  NUMBERS = (1..6).to_a

  def initialize
    @user_role = ""
    @round = 1
    @secret = []
    @guess = []
    @feedback = []
    @winner = ""
    @possible_combos = NUMBERS.repeated_permutation(4).to_a
  end

  def play
    choose_role
    if @user_role == "b"
      generate_secret
      play_rounds  
    else
      set_secret
      generate_rounds
    end
  end

  private

  def choose_role
    feedback_explanation = "Each round, feedback will be given:\n" +
      "'o' = correct number, correct position\n" +
      "'x' = correct number, wrong position\n" +
      "'n' = wrong number, wrong position"
    puts "Welcome to Mastermind!\nChoose your role:\n" +
      "Type 'b' to break the code\nType 'm' to make the code\nPress Enter to continue.."
    input = gets.chomp.downcase
    if input == "b"
      puts "You are now the Codebreaker!\nYou must break the code within 12 rounds."
      puts "#{feedback_explanation}"
      puts "The code will be a 4-digit number ranging from 1 to 6, e.g., 1234.\n" + 
      "To break the code, type the number and press Enter.." +
      "Good luck!\nPress Enter to start.."
    elsif input == "m"
      puts "You are now the Codemaker!\n" +
        "You will set the code for me to break within 12 rounds."
      puts "#{feedback_explanation}"
      puts "Good luck!\nPress Enter to start.."
    else 
      puts "Invalid input. Please try again."
      choose_role
    end
    @user_role = input
    gets
  end

  def input_valid?(input)
    input.size == 4 && input.all? { |num| NUMBERS.include?(num) }
  end  
  
  def generate_secret
    @secret = NUMBERS.sample(4)
  end

  def set_secret
    puts "Type a 4-digit number ranging from 1 to 6, e.g., 1234.\n" + 
      "Then, press Enter to set the code.."
    input = gets.chomp.chars.map(&:to_i)
    if input_valid?(input)
      @secret = input
    else
      puts "Invalid input. Please try again."
      set_secret
    end
    puts "The code has been set!\nPress Enter to let me start breaking the code.."
    gets
  end
  
  def end_game
    if @winner == "b"
      puts "\nCodebreaker wins!\n" +
        "The secret code: #{@secret.join.to_i} was guessed in #{@round} rounds!"
    else
      puts "\nCodemaker wins!\n" +
        "The secret code: #{@secret.join.to_i} was never guessed!"
    end
  end

  def display
    @guess.each_with_index do |guess, index|
        puts "Round #{index + 1}: #{@guess[index].join} #{@feedback[index].join}\n"
    end
  end
  
  def evaluate_input(input)
    feedback = []

    input.each_with_index do |num, index|
      if num == @secret[index]
        feedback << "o"
      end
    end

    input.each_with_index do |num, index|
      if num != @secret[index] && @secret.include?(num)
        feedback << "x"
      end
    end

    (4 - feedback.size).times { feedback << "n" }

    @feedback << feedback
  end
  
  def play_rounds 
    puts "Round #{@round}: What's your guess?"
    input = gets.chomp.chars.map(&:to_i)
    if !input_valid?(input)
      puts "Invalid input. Try again."
      play_rounds
    else
      @guess << input
      evaluate_input(input)
    end
    
    display

    if @secret == @guess.last
      @winner = "b"
      end_game
    elsif @round == 12
      @winner = "m"
      end_game
    else
      @round += 1
      play_rounds
    end
  end

  

  def generate_rounds
    # generate input
    input = @possible_combos.first
    # pass input to get feedback
    @guess << input
    evaluate_input(input)
    # assess feedback to generate next input
    
    # transform possible_combo for the next input
  end
  end
  
  
end

Mastermind.new.play