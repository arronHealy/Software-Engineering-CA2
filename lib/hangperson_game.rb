class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  # ruby shortcut for getter and setter methods of class variables
  attr_accessor :word, :guesses, :wrong_guesses 
  
  def initialize(word)
    # initialize variables
    @word = word
    @guesses = ''
    @wrong_guesses = ''

  end

  # define guess method
  def guess(letter)
    # check for valid letter being passed, order of checks matter when checking for nil!
    if letter.nil? or letter.empty? or letter.match(/^[[:alpha:]]+$/) == nil
        raise ArgumentError
    end

    # check for occurrence of letter in wor
    if @word.include? letter.downcase # case insensitive
        # check if letter has already been guessed
        if @guesses.include? letter.downcase # case insensitive
            return false
        else
            # append letter to guesses if first occurrence of letter
            @guesses += letter
        end
    else
        # check if wrong guesses already includes letter
        if @wrong_guesses.include? letter.downcase # case insensitive
            return false
        else
            # append to wrong guesses if first occurrence of letter
            @wrong_guesses += letter
        end
    end
  end

  # define word with guesses method to return string with correct guesses
  def word_with_guesses()
    # initialize guess variable with empty string
    guess = ''

    # loop through word to guess
    for pos in 0...@word.length
        # check if guessed letters appear in word and append to guess string position
        if @guesses.include? @word[pos]
            guess += @word[pos]
        else
            # append - character for words that haven't been guessed correctly
            guess += '-'
        end
    end

    return guess
  end

  # define method to return immutable string
  def check_win_or_lose()
    # check if wrong guesses exceeds allowable value and return game lost
    if @wrong_guesses.length > 6
        return :lose
    # check if all words guessed correctly and return game won
    elsif !self.word_with_guesses.include? '-'
        return :win
    # keep playing if first two conditions haven't returned true
    else
        return :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
