begin
    using StatsBase
    using BenchmarkTools

    file_path = "src\\2024\\03\\input.txt"
    data = read(file_path, String)
end

begin
    function p1(data)
        pattern = r"mul\((\d{1,3}),(\d{1,3})\)"
        return sum(prod(parse.(Int32, m)) for m in eachmatch(pattern, data))
    end
    @btime res1 = p1(data)
    println("res1=$(res1)")

    function p2(data)
        pattern = r"do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)"
        do_mul = true
        res = 0
        for m in eachmatch(pattern, data)
            if m.match == "do()"
                do_mul = true
            elseif m.match == "don't()"
                do_mul = false
            elseif do_mul == true
                res += prod(parse.(Int32, m.captures))
            end
        end
        return res
    end

    @btime res2 = p2(data)
    println("res2=$(res2)")
end
