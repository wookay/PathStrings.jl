# module PathStrings.Path

struct PathString
    s::String
end

macro Path_str(s)
    PathString(s)
end

# module PathStrings.Path
