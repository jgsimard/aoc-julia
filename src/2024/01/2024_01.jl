begin
    using StatsBase
    file_path = "src\\2024\\01\\input.txt"

    list1 = Int32[]
    list2 = Int32[]

    open(file_path, "r") do file
        for line in eachline(file)
            x, y = parse.(Int32, split(line))
            push!(list1, x)
            push!(list2, y)
        end
    end

    res1 = sum(abs(x - y) for (x, y) in zip(sort(list1), sort(list2)))
    d = countmap(list2)
    score = sum(e * get(d, e, 0) for e in list1)

    println("p1 :  ", res1)
    println("score = ", score)
end
