class Mastermind
  NUMBERS = (1..6).to_a

  def initialize
    @user_role = ""
    @round = 1
    @secret = []
    @guesses = []
    @feedbacks = []
    @input_pool = [[1, 1, 1, 1]]
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
      "'x' = correct number, wrong position\n"
    puts "Welcome to Mastermind!\nChoose your role:\n" +
      "Type 'b' to choose Codebreaker\nType 'm' to choose Codemaker\nPress Enter to continue.."
    input = gets.chomp.downcase
    if input == "b"
      puts "You are now the Codebreaker!\nYou must break the code within 12 rounds."
      puts "#{feedback_explanation}"
      puts "The code will be a 4-digit number ranging from 1 to 6, e.g., 1234.\n" + 
      "To submit your guess, type the number and press Enter.." +
      "Good luck!\nPress Enter to start.."
    elsif input == "m"
      puts "You are now the Codemaker!\n" +
        "You will set the code for the Codebreaker to break within 12 rounds."
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
    puts "The code has been set!\nPress Enter to start.."
    gets
  end
  
  def end_game
    if @guesses.last == @secret
      puts "\nCodebreaker wins!\n" +
        "The secret code: #{@secret.join.to_i} was guessed in #{@round - 1} rounds!"
    else
      puts "\nCodemaker wins!\n" +
        "The secret code: #{@secret.join.to_i} was never guessed!"
    end
  end

  def display
    @guesses.each_with_index do |guess, index|
        puts "Round #{index + 1}: #{@guesses[index].join} #{@feedbacks[index].join}\n"
    end
  end
  
  def get_feedback(input)
    secret = @secret.dup
    feedback = []
    
    input.each_with_index do |num, index|
      if num == secret[index]
        feedback << "o"
        secret[index] = nil
      end
    end

    input.each do |num|
      if secret.include?(num)
        feedback << "x"
        secret[secret.index(num)] = nil
      end
    end
    
    @feedbacks << feedback
  end
    
  def play_rounds 
    while @round <= 12 && @guesses.last != @secret
      puts "Round #{@round}: What's your guess?"
      input = gets.chomp.chars.map(&:to_i)
      if !input_valid?(input)
        puts "Invalid input. Try again."
        play_rounds
      else
        @guesses << input
        get_feedback(input)
        display
        @round += 1
      end
    end
    end_game
  end

  def generate_rounds
    while @round <= 12 && @guesses.last != @secret
      # generate input
      input = @input_pool.last
      # pass input to get feedback
      @guesses << input
      get_feedback(input)
      @round += 1
      
    # assess feedback and create next input
    ## 1. identify the 4 numbers, try till 1-6 used or fb = ooxx
    ## 2. try till fb = ooxx
    ## 3. try till correct
    end
  end
end

Mastermind.new.play