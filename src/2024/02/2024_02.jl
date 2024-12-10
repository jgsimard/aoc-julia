begin
    using StatsBase
    using BenchmarkTools
    file_path = "src\\2024\\02\\input.txt"

    function is_safe(v)
        diff = v[1:end-1] .- v[2:end]
        (all(diff .< 0) || all(diff .> 0)) && all(1 .<= abs.(diff) .<= 3)
    end

    function is_safe_tolerent(v)
        if is_safe(v)
            return true
        end
        for i in 1:length(v)
            if is_safe(vcat(v[1:i-1], v[i+1:end]))
                return true
            end 
        end
        return false
    end
    nb_safe = 0
    open(file_path, "r") do file
        for line in eachline(file)
            report = parse.(Int32, split(line))
            global nb_safe += Int(is_safe_tolerent(report))
        end
    end

    println("nb_safe :  $(nb_safe)")
end
