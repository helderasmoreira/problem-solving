directions = [:up, :down, :left, :right]
Cart = Struct.new(:x, :y, :direction, :intersection_decision)

carts = []

map =
  File.readlines('13.input', chomp: true).map.with_index do |line, y|
    line.chars.map.with_index do |char, x|
      direction, new_char =
        case char
        when '^'
          [:up, '|']
        when 'v'
          [:down, '|']
        when '<'
          [:left, '-']
        when '>'
          [:right, '-']
        else
          [nil, char]
        end

      carts << Cart.new(x, y, direction, [:left, :straight, :right]) if direction
      new_char
    end
  end

loop do
  break if carts.size == 1

  carts.sort_by { |cart| [cart.y, cart.x] }.each do |cart|
    case cart.direction
    when :up
      case map[cart.y - 1][cart.x]
      when '/'
        cart.direction = :right
      when '\\'
        cart.direction = :left
      when '+'
        new_direction =
          case cart.intersection_decision.first
          when :left
            :left
          when :right
            :right
          when :straight
            :up
          end

        cart.direction = new_direction
        cart.intersection_decision.rotate!
      end
      cart.y = cart.y - 1
    when :down
      case map[cart.y + 1][cart.x]
      when '/'
        cart.direction = :left
      when '\\'
        cart.direction = :right
      when '+'
        new_direction =
          case cart.intersection_decision.first
          when :left
            :right
          when :right
            :left
          when :straight
            :down
          end

        cart.direction = new_direction
        cart.intersection_decision.rotate!
      end
      cart.y = cart.y + 1
    when :left
      case map[cart.y][cart.x - 1]
      when '/'
        cart.direction = :down
      when '\\'
        cart.direction = :up
      when '+'
        new_direction =
          case cart.intersection_decision.first
          when :left
            :down
          when :right
            :up
          when :straight
            :left
          end

        cart.direction = new_direction
        cart.intersection_decision.rotate!
      end
      cart.x = cart.x - 1
    when :right
      case map[cart.y][cart.x + 1]
      when '/'
        cart.direction = :up
      when '\\'
        cart.direction = :down
      when '+'
        new_direction =
          case cart.intersection_decision.first
          when :left
            :up
          when :right
            :down
          when :straight
            :right
          end

        cart.direction = new_direction
        cart.intersection_decision.rotate!
      end
      cart.x = cart.x + 1
    end

    collision = carts.find { |c1| carts.count { |cart| cart.x == c1.x && cart.y == c1.y } > 1 }
    if collision
      puts "WE HAVE A CRASH HERE, FOLKS! WILL REMOVE THE CARTS! #{collision.x},#{collision.y}"
      carts = carts - carts.select { |cart| cart.x == collision.x && cart.y == collision.y }
    end
  end
end

p "LAST CART: #{carts}"
