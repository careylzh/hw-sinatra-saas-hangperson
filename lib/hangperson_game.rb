
class HangpersonGame
    
    
  def initialize(word)
      @word = word
      @guesses_arr = []
      @wrong_guesses_arr = []
      @num = 0
      @word_with = []
      @guesses_count = 0
  end
  attr_accessor :word ,:guesses , :wrong_guesses , :win , :lose , :play
  
  def guess(char)
     
      if  char == '' || /[A-Za-z]/ !~ char || char == nil
          raise ArgumentError
      end
       char = char.gsub(/[\s,]/ ,"")
      
      @guesses_count = char.chars.count
     
      char.chars.each do |l|
          if @word.include?(l) && ((@guesses_arr.include? l) == false)
              @guesses_arr.push(l)
              
          elsif (@word.include?(l) && ((@guesses_arr.include?(l)) == true)) || ((@wrong_guesses_arr.include?(l)) == true)
                  return false
                   
          elsif ((@wrong_guesses_arr.include?(l)) == true) || ((('A'..'Z') === l)) || (((@guesses_arr.include?(l) == true)))
                  return false     
                   
           elsif   @wrong_guesses_arr.include?(l) == false && @guesses_arr.include?(l) == false
                  @wrong_guesses_arr.push(l)
                  
          end
      end
          @wrong_guesses =  @wrong_guesses_arr.join.to_s
          @guesses = @guesses_arr.join.to_s
      
  end
  
  def word_with_guesses

      if @num == 0
          @word.chars.each do |l|
              @word_with.push("-")
          end
          @num = 1
      end
      a= @word.chars
      b=@guesses_arr.join.to_s
      for i in 0..b.size - 1
          for j in 0..@word.size
              if b[i] == a[j]
                  @word_with[j] = a[j]
              end
          end
      end
      
     @word_with.join.to_s
  
  end
  
  def check_win_or_lose
      if word_with_guesses == @word
          :win
          elsif @wrong_guesses.chars.count >= 7
          :lose
          else
          :play
      end
  end
  

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
