using IterTools

base_path = joinpath("src", "2024", "08")
filename = joinpath(base_path, "input.txt")
filename_test = joinpath(base_path, "test_input.txt")

# part 1
function parse_grid(filename)
    lines = readlines(filename)
    permutedims(hcat([collect(line) for line in lines]...))
end

function get_antenna_positions(grid)
    positions = Dict{Char, Vector{Tuple{Int, Int}}}()
    nrows, ncols = size(grid)
    for row in 1:nrows
        for col in 1:ncols
            char = grid[row, col]
            if char != '.'
                push!(get!(positions, char, []), (row, col))
            end
        end
    end
    return positions
end

function prob1(filename)
    grid = parse_grid(filename)
    nrows, ncols = size(grid)
    
    antena_positions = get_antenna_positions(grid)

    antinode_positions = Set{Tuple{Int, Int}}()
    # println(antena_positions)
    for (antena, antena_pos) in antena_positions
        for pair in IterTools.subsets(antena_pos, 2)
            delta = (pair[2] .- pair[1]) 
            maybe_antinodes = [pair[1] .- delta, pair[2] .+ delta]
            for ma in maybe_antinodes
                # println(ma)
                if  (ma[1] in 1:nrows) && (ma[2] in 1:ncols) 
                    push!(antinode_positions, ma)
                end
            end
        end
        # println(pairs)
    end
    # println(antinode_positions)
    length(antinode_positions)
end

# part 2
function prob2(filename)
    grid = parse_grid(filename)
    nrows, ncols = size(grid)
    
    antena_positions = get_antenna_positions(grid)

    antinode_positions = Set{Tuple{Int, Int}}()
    for (antena, antena_pos) in antena_positions
        for pair in IterTools.subsets(antena_pos, 2)
            delta = (pair[2] .- pair[1]) 
            for i in -100:100 # super hacky but it works
                maybe_antinode = pair[1] .-  i .* delta
                if  (maybe_antinode[1] in 1:nrows) && (maybe_antinode[2] in 1:ncols) 
                    push!(antinode_positions, maybe_antinode)
                end
            end
        end
    end
    length(antinode_positions)
end


@time prob1(filename_test)
@time prob1(filename)

@time prob2(filename_test)
@time prob2(filename)

