include Java

import java.awt.Font
import java.awt.Color
import java.awt.Rectangle
import java.awt.KeyboardFocusManager

import java.awt.event.KeyEvent

import javax.swing.Timer
import javax.swing.JFrame
import javax.swing.JPanel

require 'jruby_cursus/screen_buffer'

module JRubyCursus

  CURSUS_ZOOM_ENABLED = TRUE

  class Board < JPanel
    
    DEFAULT_SIZE = 14
    
    def initialize
      
      @column, @line = 0, 0
    
      @last_input = nil
      @cursor = Cursor.new(self)
      
      @buffer = ScreenBuffer.new
      
      @font = Font.new('courier', Font::PLAIN, DEFAULT_SIZE)
      @zoom_factor = 1
      
      KeyboardFocusManager.current_keyboard_focus_manager.add_key_event_dispatcher do |evt|
        
        if evt.getID == KeyEvent::KEY_PRESSED
          
          case evt.getKeyCode
          when KeyEvent::VK_BACK_SPACE
            @last_input = :backspace
          when KeyEvent::VK_UP
            @last_input = 'A'
          when KeyEvent::VK_RIGHT
            @last_input = 'C'
          when KeyEvent::VK_LEFT
            @last_input = 'D'
          when KeyEvent::VK_DOWN
            @last_input = 'B'
          when KeyEvent::VK_E
            @last_input = 'e'
          when KeyEvent::VK_N
            @last_input = 'n'
          when KeyEvent::VK_R
            @last_input = 'r'
          when KeyEvent::VK_ENTER
            @last_input = "\r"
          when KeyEvent::VK_ADD
            if @zoom_factor <= 4
              if CURSUS_ZOOM_ENABLED and evt.getModifiersEx & KeyEvent::CTRL_DOWN_MASK == KeyEvent::CTRL_DOWN_MASK
                @zoom_factor += 0.4
                change_zoom
              end
            end
          when KeyEvent::VK_SUBTRACT
            if @zoom_factor >= 0.6
              if CURSUS_ZOOM_ENABLED and evt.getModifiersEx & KeyEvent::CTRL_DOWN_MASK == KeyEvent::CTRL_DOWN_MASK
                @zoom_factor -= 0.2
                change_zoom
              end
            end
          when KeyEvent::VK_0
            puts "0" #if evt.getModifiersEx & KeyEvent::CTRL_DOWN_MASK == KeyEvent::CTRL_DOWN_MASK
          else
            
            code = evt.getKeyChar
            
            @last_input = code.chr unless code == KeyEvent::CHAR_UNDEFINED
            
          end
          
        end
        
        true
        
      end
      
    end
    
    def input
      ch = @last_input
      @last_input = nil
      ch
    end
    
    def display_at line, column, str
      @buffer.display_at line, column, str
    end
    
    def remove_at line, column
      @buffer.remove_at line, column
    end
    
    def at column, line
      
      @column, @line = column, line
      
      @cursor.blink
      
      repaint
      
    end
    
    def clear
      @buffer.clear
    end
    
    def paintComponent g
      
      return if @buffer.empty?

      g.color = Color::BLACK
      g.fill_rect 0, 0, width, height
      
      g.font = @font
      g.color = Color::WHITE
      
      unless @height_metrics
        
        metrics = g.font_metrics
        
        @height_metrics = metrics.height.to_i
        
        @cursor.width = metrics.max_advance.to_i
        @cursor.height = @height_metrics

     end

      y = 0

      @buffer.each do |row|
        
        y += @height_metrics

        g.drawString row, 0, y if row
        
      end
      
      @cursor.paint g, @column, @line
      
    end
    
    def change_zoom
      
      @font = Font.new('courier', Font::PLAIN, (DEFAULT_SIZE * @zoom_factor).round)
      
      @height_metrics = nil
      
      repaint
      
    end
    
  end

  class Cursor
    
    def initialize component
      
      @component = component
      
      @state_on = true
      
      @height = @width = 10
      
    end
    
    def height= height
      @height = height
    end
    def width= width
      @width = width
    end
    
    def hide
      @timer.stop
    end
    
    def blink
      
      unless @timer
      
        @timer = Timer.new(500, nil)
        @timer.initial_delay = 0
        
        @timer.add_action_listener do |evt|
          @state_on = !@state_on
          @component.repaint
        end
      
      end
      
      @timer.start
      
    end
    
    def paint g, column, line
      
      return unless Curses.cursor_visibile?
      
      g.color = @state_on ? Color::WHITE : Color::BLACK
      
      g.fill_rect column * (@width - 1), line * @height + 5, @width - 1, @height - 4
    
    end
    
  end
  
end

module Curses

  @@cursor_visibility = 1
  
  def self.cursor_visibile?
    @@cursor_visibility != 0
  end

  @@echo_on = false
  
  def self.echo?
    @@echo_on
  end
  
  def self.addch ch
  end
  
  def self.addstr str
  end
  
  def self.beep
  end
  
  def self.cbreak
  end
  
  def self.clear
  end
  
  def self.close_screen
  end
  
  def self.closed?
  end
  
  def self.clrtoeol
  end
  
  def self.crmode
  end

  # Sets Cursor Visibility. 0: invisible 1: visible 2: very visible
  def self.curs_set visibility
    @@cursor_visibility = visibility
  end
  
  def self.delch
  end
  
  def self.deleteln
  end
  
  def self.doupdate
  end
  
  def self.echo
    @@echo_on = true
  end
  
  def self.flash
  end
  
  def self.getch
  end
  
  def self.getstr
  end
  
  def self.inch
  end
  
  def self.init_screen
    
    $board = JRubyCursus::Board.new
    
    $frame = JFrame.new("Swing/Curses")
    
    $frame.add $board
    $frame.background = Color::BLACK
    
    $frame.default_close_operation = JFrame::EXIT_ON_CLOSE
    $frame.set_size 800, 600
    $frame.visible = true

  end
  
  def self.insch ch
  end
  
  def self.insertln
  end
  
  def self.keyname c
  end
  
  def self.nl
  end
  
  def self.nocbreak
  end
  
  def self.nocrmode
  end
  
  def self.noecho
    @@echo_on = false
  end
  
  def self.nonl
  end
  
  def self.noraw
  end
  
  def self.raw
  end
  
  def self.refresh
  end
  
  def self.setpos line, column
  end
  
  def self.standend
  end
  
  def self.standout
  end
  
  def self.stdscr
  end
  
  def self.ungetch ch
  end
  
  class Window
    
    def initialize h, w, line, column
      
      @width = w
      @height = h
      @origin_line = line
      @origin_column = column
      
      @cursor_line = 0
      @cursor_column = 0
      
    end
      
    def close
      
      @empty_line = ' ' * @width unless @empty_line
      
      @height.times do |line|
        $board.display_at @origin_line + line, @origin_column, @empty_line
      end
      
    end
    
    def clear
      $board.clear
    end
    
    def setpos line, column
      
      @cursor_line = line
      @cursor_column = column
      
      $board.at @origin_column + column, @origin_line + line
      
    end
    
    def addstr str
      
      line = @origin_line + @cursor_line
      
      str.each_line do |str|
        
        @cursor_column = 0
        
        $board.display_at line, @origin_column + @cursor_column, str
        
        @cursor_column += str.size
        
        line += 1
        
      end
      
    end
    
    def getch
      
      @stop_column = @cursor_column
      
      input_character
    
    end

    def getstr
    
      @stop_column = @cursor_column
      
      buffer = ''
      
      loop do
      
        ch = input_character
      
        if ch == :backspace
          buffer.chop! unless @stop_column == @cursor_column
          next
        end
        
        break if ch =~ /[\r\n]/
        
        buffer << ch
        
      end
      
      buffer
    
    end
    
    def move line, column
      @origin_line = line
      @origin_column = column
    end
  
    def refresh
      $board.repaint
    end
    
    def nodelay= state
    end
    
    def debug
      
      def self.addstr str
        super
      end
      
    end

    def echo ch
      
      return unless ch
      
      line = @origin_line + @cursor_line
      column = @origin_column + @cursor_column
      
      if ch == :backspace
        
        return if @stop_column == @cursor_column
        
        @cursor_column -= 1
        $board.remove_at line, column - 1
        
      else
        @cursor_column += 1
        $board.display_at line, column, ch
      end
    
      $board.repaint
      
    end
    
    def input_character
      
      loop do
        
        ch = $board.input
        
        echo ch if Curses.echo?
        
        return ch if ch
        
        sleep 0.01
        
      end
      
    end
    
  end
  
end
