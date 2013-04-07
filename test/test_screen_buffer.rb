require 'test/unit'

require 'jruby_curses/screen_buffer'

module JRubyCurses

  class TestStyles < Test::Unit::TestCase
    
    def setup
      @screen = ScreenBuffer.new
    end
    
    def test_add_new_line_on_empty_screen
      
      @screen.display_at 2, 0, "Hello"
      
      assert_equal [nil, nil, "Hello"], @screen.to_a

    end
    
    def test_overwrite_characters
      
      @screen.display_at 2, 0, "Hello"
      @screen.display_at 2, 2, "--"
      
      assert_equal [nil, nil, "He--o"], @screen.to_a

    end
      
    def test_append_characters_to_existing_line
      
      @screen.display_at 2, 0, "Hello"
      @screen.display_at 2, 6, "world"
      
      assert_equal [nil, nil, "Hello world"], @screen.to_a

    end
    
    def test_add_characters_on_new_line
      
      @screen.display_at 2, 3, "hello"
      
      assert_equal [nil, nil, "   hello"], @screen.to_a

    end
    
    def test_add_new_line_in_the_middle_of_existing_lines
      
      @screen.display_at 4, 3, "world"
      @screen.display_at 2, 1, "hello"
      
      assert_equal [nil, nil, " hello", nil, "   world"], @screen.to_a

    end
    
    def test_add_line_with_new_line_at_end_of_line
      
      @screen.display_at 2, 3, "hello\n"
      
      assert_equal [nil, nil, "   hello"], @screen.to_a

    end
    
    def test_add_line_with_cr_at_end_of_line
      
      @screen.display_at 2, 3, "hello\r"
      
      assert_equal [nil, nil, "   hello"], @screen.to_a

    end
    
  end
  
end
