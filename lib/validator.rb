class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    # Create a 2D array to hold the sudoku values
    sudoku_array = create_sudoku_array(@puzzle_string)

    # Check if the puzzle is valid
    if valid_sudoku?(sudoku_array)
      # Check if the puzzle is complete
      if complete_sudoku?(sudoku_array)
        'Sudoku is valid.'
      else
        'Sudoku is valid but incomplete.'
      end
    else
      'Sudoku is invalid.'
    end
  end

  private

  def create_sudoku_array(sudoku_string)
    # Split the string into rows
    rows = sudoku_string.split("\n")

    # Create a 2D array to hold the sudoku values
    sudoku_array = []

    # Loop through each row and split it into individual characters
    rows.each do |row|
      values = row.chars

      # Remove empty spaces from the row
      values.reject! { |value| [' ', '-', '+', '|'].include?(value) }

      # Convert the remaining values to integers
      next if values.empty?

      sudoku_row = values.map(&:to_i)

      # Add the row to the sudoku array
      sudoku_array << sudoku_row
    end

    sudoku_array
  end

  def valid_sudoku?(sudoku_array)
    # Check rows for duplicates
    sudoku_array.each do |row|
      non_zero_values = row.reject { |x| x == 0 }
      return false if non_zero_values.uniq.length != non_zero_values.length
    end

    # Check columns for duplicates
    sudoku_array.transpose.each do |column|
      non_zero_values = column.reject { |x| x == 0 }
      return false if non_zero_values.uniq.length != non_zero_values.length
    end

    # Check 3x3 squares for duplicates
    (0..8).step(3) do |i|
      (0..8).step(3) do |j|
        square = sudoku_array[i, 3].map { |row| row[j, 3] }.flatten
        non_zero_values = square.reject { |x| x == 0 }
        return false if non_zero_values.uniq.length != non_zero_values.length
      end
    end

    # Check that only numbers 1-9 are used
    sudoku_array.flatten.each do |value|
      return false if value < 0 || value > 9
    end

    true
  end

  def complete_sudoku?(sudoku_array)
    # Check if any cells are empty
    sudoku_array.flatten.each do |value|
      return false if value == 0
    end

    true
  end
end