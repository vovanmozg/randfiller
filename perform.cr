class Calc
  W = 20
  H = 20

  @matrix: Array(Array(Int32))
  @filled_amount: Int32

  def initialize
    
    @matrix = (0...H).map { |row| (0...W).to_a.map { 0 } }
    
    @x = 0
    @y = 0
    @steps_amount = 0
    @filled_amount = 0
    #@x = 0
    #@y = 0
    @directions = [[1, 0], [0, -1], [-1, 0], [0, 1]]
    #@steps_amount = 0
    #@filled_amount = 0

    #@matrix[@x][@y] = 0
    
  end

  def step
    rand_move do |newX, newY|
      @steps_amount += 1
      @filled_amount += 1 if @matrix[@x][@y] == 0
    end
  end

  def self.run_epoch
    runs_count = 100_000
    stat = Hash(Int32, Int32).new(0)
    runs_count.times do
      x = Calc.new.run
      stat[x] += 1
    end

    stat
  end

  def reset
    @matrix = (0...H).map { |row| (0...W).to_a.map { 0 } }
    @x = 0
    @y = 0
    @steps_amount = 0
    @filled_amount = 0
  end

  def run
    while @filled_amount < W * H
      step
      # p @matrix.map {|row| row.join(' ')}.join('-')
    end

    @steps_amount
  end

  def rand_move
    direction = @directions.sample

    newX = @x + direction[0]
    newY = @y + direction[1]

    return if newX < 0 || newX >= W
    return if newY < 0 || newY >= H

    @x = newX
    @y = newY

    yield newX, newY

    @matrix[@x][@y] = 1 
  end
end

stat = Calc.run_epoch

# Render

File.open("./data.txt", "w") do |file|
  stat.keys.sort.each do |key|
    file.print("#{key}\t#{stat[key]}\n")
  end  
end


