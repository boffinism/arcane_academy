require_relative '../logic_engine/all'

module Console
  class Game
    def run
      @running = true

      @level_controller = LogicEngine::LevelController.new(1)
      @level_controller.when_message { |m| write_line m }

      write_intro_text

      run_game_loop
    end

    private

    def write_intro_text
      write_line 'Welcome to Arcane Academy'
      write_line 'This is your first class'
      describe_surroundings

      describe_challenge
      describe_available_words

      describe_options
    end

    def run_game_loop
      while @running
        describe_selected_words
        process_inputs(read_line)
      end
    end

    def read_line
      $stdout.print '> '
      $stdin.gets.chomp.split
    end

    def write_line(text)
      $stdout.puts text
    end

    def describe_surroundings
      write_line 'These are your surroundings:'
      @level_controller.things.each do |thing|
        write_line thing
      end
    end

    def describe_challenge
      write_line "Your challenge is: #{@level_controller.challenge_text}"
    end

    def describe_options
      write_line "To select a word type 's <word>'"
      write_line "To quit type 'q'"
      write_line "To remove a word type 'd <word_id>'"
      write_line "To cast your spell type 'c'"
    end

    def describe_selected_words
      spell = ''
      @level_controller.selected_words.each do |selected_word|
        spell += "(#{selected_word.id}) #{selected_word.word} "
      end
      if spell != ''
        write_line "Your spell so far is: #{spell}"
      else
        write_line 'Start selecting words for your spell'
      end
    end

    def describe_available_words
      write_line 'Your available words are:'
      @level_controller.available_word_definitions.each do |definition|
        write_line definition
      end
    end

    def find_selected_word(word_id)
      sw = @level_controller.selected_words.select do |selected_word|
        selected_word.id.to_s == word_id
      end
      sw.first
    end

    INPUT_COMMANDS = { 's' => :select_word,
                       'd' => :delete_word,
                       'q' => :quit_game,
                       'c' => :cast_spell }.freeze

    def process_inputs(inputs)
      command = INPUT_COMMANDS[inputs[0]]
      if command
        send command, inputs[1]
      else
        write_line 'What?'
      end
    end

    def select_word(word)
      @level_controller.select_word word
    end

    def delete_word(word_id)
      @level_controller.delete_word find_selected_word(word_id)
    end

    def cast_spell(_input)
      @level_controller.cast_spell
      describe_surroundings
      if @level_controller.challenge_met?
        write_line 'You have succeeded! You win!'
        @running = false
      else
        describe_challenge
      end
    end

    def quit_game(_input)
      write_line 'Byebye!'
      @running = false
    end
  end
end
