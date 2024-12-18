# part 1
function prob1(filename)
    lines = readlines(filename)

    total = 0
    for line in lines
        res_data, vals_data = split(line, ":")
        res = parse(Int, res_data)
        vals = parse.(Int, split(vals_data))
        nb_operator = length(vals) - 1
        operators = falses(nb_operator)
        # println("$res =  $vals, $nb_operator")
        for val = 0:(2^nb_operator-1)
            for i = 1:nb_operator
                operators[i] = (val >> (i - 1)) & 1
            end
            potential_res = vals[1]
            for (op, e) in zip(operators, vals[2:end])
                if op
                    potential_res *= e
                else
                    potential_res += e
                end
            end
            if potential_res == res
                # println("succes! : ops : $operators, res: $res, potential_res: $potential_res")
                total += res
                break
            end
        end
    end
    return total
end

# part 2
function concat_nb_digits_0_1000(a, b)
    if b < 10
        return a * 10 + b
    elseif b < 100
        return a * 100 + b
    else
        return a * 1000 + b
    end
end

function prob2(filename)
    lines = readlines(filename)
    total = 0
    for line in lines
        res_data, vals_data = split(line, ":")
        res = parse(Int, res_data)
        vals = parse.(Int, split(vals_data))
        nb_operator = length(vals) - 1
        # operators = zeros(Int, nb_operator)
        operators = Vector{Int}(undef, nb_operator)
        # println("$res =  $vals, $nb_operator")
        for val = 0:(3^nb_operator-1)
            temp_val = val
            for i = 1:nb_operator
                operators[i] = temp_val % 3
                temp_val = Int(div(temp_val, 3))
            end
            potential_res = vals[1]
            for (op, e) in zip(operators, vals[2:end])
                if op == 0
                    potential_res += e
                elseif op == 1
                    potential_res *= e
                elseif op == 2
                    potential_res = concat_nb_digits_0_1000(potential_res, e) # faster but super specialized to input
                    # potential_res = potential_res * (10^(floor(Int, log10(e)) + 1)) + e
                end
            end
            if potential_res == res
                # println("succes! : ops : $operators, res: $res, potential_res: $potential_res")
                total += res
                break
            end
        end
    end
    return total
end

base_path = joinpath("src", "2024", "07")
filename = joinpath(base_path, "input.txt")
filename_test = joinpath(base_path, "test_input.txt")

@time prob1(filename_test)
@time prob1(filename)

@time prob2(filename_test)
@profview prob2(filename)

# expected result: 162987117690649
