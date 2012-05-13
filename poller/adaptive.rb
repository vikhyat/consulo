class AdaptivePolling
  def initialize(type, options={})
    @delay  = options[:delay] || 2.0
    @max    = options[:max]   || 5.0
    @min    = options[:min]   || 0.5
    
    @type = type
    if @type == 'single'
      @alpha  = options[:alpha] || 0.8
      @delta  = options[:delta] || 1.0
      @s      = 0.0 # initial forecast
    elsif @type == 'double'
      @alpha = @options[:alpha] || 0.8
      @beta  = @options[:beta]  || 0.7
      @delta = @options[:delta] || 0.01
      @sc = 0.0 # S_(t+1)
      @sp = 0.0 # S_(t+1)
      @bc = 0.0 # b_(t+1)
      @bp = 0.0 # b_t
    end
  end
  
  def register(value)
    begin
      value = value.to_i
      if @type == 'single'
        if (@s - value).abs > @delta
          @delay *= 0.5
        else
          @delay *= 1.1
        end
        @delay = @max if @delay > @max
        @delay = @min if @delay < @min
        @s = @alpha * value + (1 - @alpha) * @s
      elsif @type == 'double'
        if (@sc - value).abs / value.to_f > @delta
          @delay *= 0.5
        else
          @delay *= 1.1
        end
        @sc, @sp = @alpha * value + (1 - @alpha) * (@sp + @bp), @sc
        @bc, @bp = @beta * (@sc - @sp) + (1 - @beta) * @bp, @bc
        @delay = @max if @delay > @max
        @delay = @min if @delay < @min
      end
    rescue
    end
  end
  
  def wait_time
    @delay
  end
end