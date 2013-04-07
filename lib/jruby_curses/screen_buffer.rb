#encoding: utf-8

module JRubyCurses

  class ScreenBuffer
    
    def initialize
      @content_by_row = []
    end
    
    def display_at row, col, str
      
      str = str.chomp
      
      if @content_by_row[row]
        
        if col > @content_by_row[row].length
          @content_by_row[row] << ' ' * (col - @content_by_row[row].length)
          @content_by_row[row] << str
        else
          @content_by_row[row][col, str.length] = str
        end
        
      else
        @content_by_row[row] = ' ' * col
        @content_by_row[row] << str
      end
      
    end

    def remove_at row, col
      
      if @content_by_row[row]
        @content_by_row[row].slice!(col)
      end
      
    end
    
    def each
      @content_by_row.each {|row| yield row}
    end
    
    def clear
      @content_by_row.clear
    end
    
    def empty?
      @content_by_row.empty?
    end
    
    def to_a
      @content_by_row
    end
    
  end
  
end
