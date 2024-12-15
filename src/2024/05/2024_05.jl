using StatsBase
using BenchmarkTools

function parse_data(data)
    rules_data, updates_data = split(data, "\n\n")
    rules = [parse.(Int, split(line, "|")) for line in split(rules_data, "\n")]
    updates = [parse.(Int, split(line, ",")) for line in split(updates_data, "\n")]
    return rules, updates
end

begin
    function is_in_order(update, rules)
        # Build a dictionary to quickly find the index of each page in this update
        idx_map = Dict{Int,Int}()
        for (i, pg) in enumerate(update)
            idx_map[pg] = i
        end

        # Check ordering
        in_order = true
        for (x, y) in rules
            if haskey(idx_map, x) && haskey(idx_map, y)
                # If x|y is violated in this update, mark invalid and break
                if idx_map[x] >= idx_map[y]
                    in_order = false
                    break
                end
            end
        end
        return in_order
    end


    function topological_sort(update, rules)
        pages = Set(update)

        adjacency = Dict{Int,Vector{Int}}()
        in_degree = Dict{Int,Int}()

        for p in pages
            adjacency[p] = Int[]
            in_degree[p] = 0
        end

        # Add edges based on relevant rules
        for (x, y) in rules
            if (x in pages) && (y in pages)
                push!(adjacency[x], y)
                in_degree[y] += 1
            end
        end

        # Topological sort (Kahn’s algorithm)
        queue = [p for p in pages if in_degree[p] == 0]
        sorted_result = Int[]

        while !isempty(queue)
            node = popfirst!(queue)
            # if node in pages
            push!(sorted_result, node)
            # end
            for nxt in adjacency[node]
                in_degree[nxt] -= 1
                if in_degree[nxt] == 0
                    push!(queue, nxt)
                end
            end
        end

        if length(sorted_result) < length(pages)
            error("Cycle detected in subgraph. Can't reorder uniquely.")
        end

        return sorted_result
    end

    function prob1(file_path)
        data = read(file_path, String)
        rules, updates = parse_data(data)

        total = 0
        for update in updates
            if is_in_order(update, rules)
                middle_page = update[div(length(update), 2)+1]
                total += middle_page
            end
        end

        return total
    end

    function prob2(file_path)
        data = read(file_path, String)
        rules, updates = parse_data(data)

        total = 0
        for update in updates
            if !is_in_order(update, rules)
                sorted_update = topological_sort(update, rules)
                middle_page = sorted_update[div(length(sorted_update), 2)+1]
                total += middle_page
            end
        end

        return total
    end

    file_path = "src\\2024\\05\\input.txt"
    println(prob1(file_path))
    println(prob2(file_path))
end
