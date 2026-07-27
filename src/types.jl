# module PathStrings

struct Path
    s::String
end

macro Path_str(s)
    Path(s)
end

# module PathStrings
