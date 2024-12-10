begin
    using StatsBase
    using BenchmarkTools

    function read_to_2d_array(file_path)
        lines = readlines(file_path)
        return [lines[i][j] for i in 1:length(lines), j in 1:length(lines[1])]
    end

    function count_word_occurrences(grid, word)
        nrows, ncols = size(grid)
        word_length = length(word)
        directions = [
            (0, 1),  # right
            (0, -1), # left
            (1, 0),  # down
            (-1, 0), # up
            (1, 1),  # down-right
            (-1, -1),# up-left
            (1, -1), # down-left
            (-1, 1)  # up-right
        ]
        count = 0    
        for i in 1:nrows
            for j in 1:ncols
                for (di, dj) in directions
                    match = true
                    for k in 0:(word_length - 1)
                        ii = i + k * di
                        jj = j + k * dj
                        if !(ii in  1:nrows) || !(jj in  1:ncols) || grid[ii, jj] != word[k + 1]
                            match = false
                            break
                        end
                    end
                    count += match ? 1 : 0
                end
            end
        end
        return count
    end

    function count_xmas(grid)
        nrows, ncols = size(grid)
        count = 0    
        for i in 2:(nrows-1)
            for j in 2:(ncols-1)
                if grid[i, j] != 'A'
                    continue
                end
                # M.S
                # .A.
                # M.S
                if (grid[i-1, j-1] == 'M') && (grid[i-1, j+1] == 'M') && (grid[i+1, j-1] == 'S') && (grid[i+1, j+1] == 'S')
                    count += 1
                    # println("(i,j) = ($i,$j) v1")
                # M.M
                # .A.
                # S.S
                elseif (grid[i-1, j-1] == 'M') && (grid[i-1, j+1] == 'S') && (grid[i+1, j-1] == 'M') && (grid[i+1, j+1] == 'S')
                    count += 1
                    # println("(i,j) = ($i,$j) v2")
                # S.M
                # .A.
                # S.M
                elseif (grid[i-1, j-1] == 'S') && (grid[i-1, j+1] == 'S') && (grid[i+1, j-1] == 'M') && (grid[i+1, j+1] == 'M')
                    count += 1
                    # println("(i,j) = ($i,$j) v3")
                # S.S
                # .A.
                # M.M
                elseif (grid[i-1, j-1] == 'S') && (grid[i-1, j+1] == 'M') && (grid[i+1, j-1] == 'S') && (grid[i+1, j+1] == 'M')
                    count += 1
                    # println("(i,j) = ($i,$j) v4")
                end
            end
        end
        return count
    end
    
    file_path = "src\\2024\\04\\input.txt"
    word = "XMAS"
    grid = read_to_2d_array(file_path)
    result = count_word_occurrences(grid, word)
    println("Total occurrences of '$word': $result")
    res2 = count_xmas(grid)
    println("Total occurrences of X-MAS: $res2")

    function pretty_print(array::Matrix{Char})
        for row in eachrow(array)
            println(join(row, " ")) 
        end
    end
    # pretty_print(grid)
end
