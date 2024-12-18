function orientation_from_char(ch::Char)::Int
    # '^' -> 0, '>' -> 1, 'v' -> 2, '<' -> 3
    return ch == '^' ? 0 :
           ch == '>' ? 1 :
           ch == 'v' ? 2 : ch == '<' ? 3 : error("Invalid guard orientation char: $ch")
end

function parse_guard_map(filename::String)
    input_lines = readlines(filename)
    rows = length(input_lines)
    cols = maximum(length.(input_lines))

    obstacle_map = falses(rows, cols)

    guard_row = 0
    guard_col = 0
    guard_orientation = 0
    found_guard = false

    for (r, line) in enumerate(input_lines)
        for (c, ch) in enumerate(line)
            if ch == '#'
                obstacle_map[r, c] = true
            elseif !found_guard && ch in ('^', 'v', '<', '>')
                guard_row, guard_col = r, c
                guard_orientation = orientation_from_char(ch)
                found_guard = true
            end
        end
    end

    if !found_guard
        error("Guard not found in $filename")
    end

    return obstacle_map, guard_row, guard_col, guard_orientation, rows, cols
end

# Offsets: orientation index 0=up,1=right,2=down,3=left
const DR = Int[-1, 0, 1, 0]
const DC = Int[0, 1, 0, -1]

function solve_guard_patrol(filename::String)
    obstacle_map, guard_row, guard_col, guard_orientation, rows, cols =
        parse_guard_map(filename)

    visited = falses(rows, cols)
    visited[guard_row, guard_col] = true

    while true
        next_r = guard_row + DR[guard_orientation+1]
        next_c = guard_col + DC[guard_orientation+1]

        # Out-of-bounds
        if !(1 ≤ next_r ≤ rows && 1 ≤ next_c ≤ cols)
            break
        end

        # obstacle => turn right
        if obstacle_map[next_r, next_c]
            guard_orientation = (guard_orientation + 1) % 4
        else
            # Move
            guard_row, guard_col = next_r, next_c
            visited[guard_row, guard_col] = true
        end
    end

    return count(visited)
end

function guard_stuck_in_loop!(
    obstacle_map::BitMatrix,
    start_row::Int,
    start_col::Int,
    start_orientation::Int,
    rows::Int,
    cols::Int,
)::Bool
    # 3D bitarray: visited_states[ori, row, col]
    visited_states = falses(4, rows, cols)

    row = start_row
    col = start_col
    ori = start_orientation
    visited_states[ori+1, row, col] = true

    while true
        nr = row + DR[ori+1]
        nc = col + DC[ori+1]

        # out-of-bounds => guard leaves map => not stuck
        if !(1 ≤ nr ≤ rows && 1 ≤ nc ≤ cols)
            return false
        end

        # if obstacle => turn right
        if obstacle_map[nr, nc]
            ori = (ori + 1) % 4
        else
            row, col = nr, nc
        end

        if visited_states[ori+1, row, col]
            return true
        end
        visited_states[ori+1, row, col] = true
    end
end


function solve_guard_part2(filename::String)
    obstacle_map, guard_row, guard_col, guard_orientation, rows, cols =
        parse_guard_map(filename)

    loop_positions = 0

    for r = 1:rows
        for c = 1:cols
            if obstacle_map[r, c]
                continue  # already obstacle
            end
            if r == guard_row && c == guard_col
                continue  # guard start not allowed
            end

            # place obstacle
            obstacle_map[r, c] = true

            if guard_stuck_in_loop!(
                obstacle_map,
                guard_row,
                guard_col,
                guard_orientation,
                rows,
                cols,
            )
                loop_positions += 1
            end

            # remove obstacle
            obstacle_map[r, c] = false
        end
    end

    return loop_positions
end

file_path = joinpath("src", "2024", "06", "input.txt")
file_path_test = joinpath("src", "2024", "06", "test_input.txt")

@time solve_guard_patrol(file_path_test)
@time solve_guard_patrol(file_path)

@time solve_guard_part2(file_path_test)
@time solve_guard_part2(file_path)
