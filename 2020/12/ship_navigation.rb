X_ACTIONS = %w[E W].freeze
TURN_ACTIONS = %w[L R].freeze
TURN_DIRS = %w[N E S W].freeze
NEG_ACTIONS = %w[W S L].freeze

def navigate(instructions, use_waypoint = false)
  facing = 'E'
  x = 0
  y = 0
  x_wp = 10
  y_wp = 1
  instructions.each do |(action, value)|
    value *= -1 if NEG_ACTIONS.include?(action)
    case action
    when 'N', 'S'
      if use_waypoint
        y_wp += value
      else
        y += value
      end
    when 'E', 'W'
      if use_waypoint
        x_wp += value
      else
        x += value
      end
    when 'F'
      if use_waypoint
        x += value * x_wp
        y += value * y_wp
      elsif X_ACTIONS.include?(facing)
        x += value
      else
        y += value
      end
    when 'L', 'R'
      if use_waypoint
        value = value.abs
        if value == 180
          x_wp = -1 * x_wp
          y_wp = -1 * y_wp
        elsif (value == 90 && action == 'R') ||
              (value == 270 && action == 'L')
          y_wp_old = y_wp
          y_wp = -1 * x_wp
          x_wp = y_wp_old
        elsif (value == 270 && action == 'R') ||
              (value == 90 && action == 'L')
          x_wp_old = x_wp
          x_wp = -1 * y_wp
          y_wp = x_wp_old
        end
      else
        value /= 90
        index = TURN_DIRS.index(facing)
        facing = TURN_DIRS[(index + value) % 4]
      end
    end
  end
  x.abs + y.abs
end

f = File.new('input.txt')
instructions = f.readlines.map do |line|
  action = line.chars.first
  value = line[1..-1].to_i
  [action, value]
end
puts navigate(instructions)
puts navigate(instructions, true)
