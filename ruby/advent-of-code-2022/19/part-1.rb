require 'set'

TIME_TO_RUN = 24

Blueprint = Struct.new(:id, :ore_robot, :clay_robot, :obsidian_robot, :geode_robot)
State = Struct.new(:robots, :materials, :remaining_time)

blueprints = File.readlines('puzzle.input', chomp: true).map do |line|
  line.match(/Blueprint (\d*):.*(\d+) ore.*(\d+) ore.*(\d+) ore and (\d+) clay.*(\d+) ore and (\d+) obsidian./).captures.map(&:to_i).then do |tokens|
    Blueprint.new(tokens[0], tokens[1], tokens[2], { ore: tokens[3], clay: tokens[4] }, { ore: tokens[5], obsidian: tokens[6] })
  end
end

def posssible_geodes_for_remaining_time(time)
 (time - 1) * (time) / 2
end

results = blueprints.map do |blueprint|
  puts blueprint

  max = {
    ore: [blueprint.ore_robot, blueprint.clay_robot, blueprint.obsidian_robot[:ore], blueprint.geode_robot[:ore]].max,
    clay: blueprint.obsidian_robot[:clay],
    obsidian: blueprint.geode_robot[:obsidian]
  }

  queue = [
    State.new(
      { ore: 1, clay: 0, obsidian: 0, geode: 0 },
      { ore: 0, clay: 0, obsidian: 0, geode: 0 },
      TIME_TO_RUN
    )
  ]

  best_geode_state = State.new(nil, { geode: 0 }, 0)
  seen = {}

  while queue.any?
    current = queue.shift

    if current.remaining_time == 0
      best_geode_state = current if current.materials[:geode] > best_geode_state.materials[:geode]
      next
    end

    # cut if we already saw this exact state
    cache_key = current.materials.values[0..-2].concat(current.robots.values)
    cached_version = seen.fetch(cache_key, [-1, -1])

    next if cached_version[0] >= current.materials[:geode] && cached_version[1] >= current.remaining_time
    seen[cache_key] = [current.materials[:geode], current.remaining_time]

    # cut if current geodes can't beat already found best geodes
    next if current.materials[:geode] + (current.robots[:geode] * current.remaining_time) + posssible_geodes_for_remaining_time(current.remaining_time) <= best_geode_state.materials[:geode]

    # adjust materials to be passed to new states
    updated_materials = current.robots.map { |type, value| [type, current.materials[type] + value] }.to_h

    # collect & build a geode robot if we CAN and NEED it
    if current.materials[:ore] >= blueprint.geode_robot[:ore] &&
       current.materials[:obsidian] >= blueprint.geode_robot[:obsidian]
      queue.unshift(State.new(
        current.robots.clone.tap { |r| r[:geode] += 1 },
        updated_materials.clone.tap { |m| m[:ore] -= blueprint.geode_robot[:ore]; m[:obsidian] -= blueprint.geode_robot[:obsidian] },
        current.remaining_time - 1
      ))
    end

    # collect & build an obsidian robot if we CAN and NEED it
    if current.materials[:ore] >= blueprint.obsidian_robot[:ore] &&
       current.materials[:clay] >= blueprint.obsidian_robot[:clay] &&
       current.robots[:obsidian] < max[:obsidian]
      queue.unshift(State.new(
        current.robots.clone.tap { |r| r[:obsidian] += 1 },
        updated_materials.clone.tap { |m| m[:ore] -= blueprint.obsidian_robot[:ore]; m[:clay] -= blueprint.obsidian_robot[:clay] },
        current.remaining_time - 1
      ))
    end

    # collect & build a clay robot if we CAN and NEED it
    if current.materials[:ore] >= blueprint.clay_robot &&
       current.robots[:clay] < max[:clay]
      queue.unshift(State.new(
        current.robots.clone.tap { |r| r[:clay] += 1 },
        updated_materials.clone.tap { |m| m[:ore] -= blueprint.clay_robot },
        current.remaining_time - 1
      ))
    end

    # collect & build an ore robot if we CAN and NEED it
    if current.materials[:ore] >= blueprint.ore_robot &&
       current.robots[:ore] < max[:ore]
      queue.unshift(State.new(
        current.robots.clone.tap { |r| r[:ore] += 1 },
        updated_materials.clone.tap { |m| m[:ore] -= blueprint.ore_robot },
        current.remaining_time - 1
      ))
    end

    # unless we have enough to build any robot (so we don't need more?), consider just collecting
    queue.unshift(State.new(
      current.robots.clone,
      updated_materials.clone,
      current.remaining_time - 1
    ))
  end

  puts best_geode_state
  best_geode_state
end

puts results.each_with_index.map { |result, i| (i + 1) * result.materials[:geode] }.sum
