Language = {
    pronouns = {
        ["um"]   = true,
        ["uma"]  = true,
        ["uns"]  = true,
        ["umas"] = true,
        ["a"]    = true,
        ["o"]    = true,
        ["as"]   = true,
        ["os"]   = true,
    },

    personal_pronoun  = {
        ["nele"]  = true,
        ["neles"] = true,
        ["nela"]  = true,
        ["nelas"] = true,
        ["dele"]  = true,
        ["dela"]  = true,
        ["ele"]   = true,
        ["ela"]   = true,
        ["deles"] = true,
        ["delas"] = true,
        ["eles"]  = true,
        ["elas"]  = true,
    },

    prepositions = {
        ["na"]  = true,
        ["nas"] = true,
        ["no"]  = true,
        ["nos"] = true,
        ["num"] = true,
    },

    list_separators = {
        [","] = true,
        ["e"] = true
    },

    infinitive =
        function (word)
            if word:sub(-3,-1) == "gue" then
                return word:sub(1,-3).."ar"
            end

            if word:sub(-3,-1) == "que" then
                return word:sub(1,-4).."car"
            end

            if word:sub(-2,-1) == "ga" then
                return word:sub(1,-2).."ar"
            end

            if word:sub(-2,-1) == "ie" then
                return word:sub(1,-2).."ar"
            end

            if word:sub(-2,-1) == "se" then
                return word:sub(1,-2).."ar"
            end

            if word:sub(-2,-1) == "te" then
                return word:sub(1,-2).."ar"
            end

            if word:sub(-2,-1) == "va" then
                return word:sub(1,-2).."er"
            end

            if word:sub(-2,-1) == "ra" then
                return word:sub(1,-2).."ir"
            end

            if word:sub(-2,-1) == "ia" then
                return word:sub(1,-4).."er"
            end

            return word
        end
    ,
}
