local accent_letters = {
  ["Á"]= "a", ["á"]= "a", ["À"]= "a", ["à"]= "a", ["Â"]= "a", ["â"]= "a", ["Ä"]= "a", ["ä"]= "a",
  ["Ã"]= "a", ["ã"]= "a", ["Å"]= "a", ["å"]= "a", ["Ā"]= "a", ["ā"]= "a", ["Ă"]= "a", ["ă"]= "a",
  ["Ą"]= "a", ["ą"]= "a", ["Ć"]= "c", ["ć"]= "c", ["Ĉ"]= "c", ["ĉ"]= "c", ["Ç"]= "c", ["ç"]= "c",
  ["Ċ"]= "c", ["ċ"]= "c", ["Č"]= "c", ["č"]= "c", ["Ď"]= "d", ["ď"]= "d", ["Đ"]= "d", ["đ"]= "d",
  ["È"]= "e", ["è"]= "e", ["É"]= "e", ["é"]= "e", ["Ê"]= "e", ["ê"]= "e", ["Ë"]= "e", ["ë"]= "e",
  ["Ē"]= "e", ["ē"]= "e", ["Ĕ"]= "e", ["ĕ"]= "e", ["Ė"]= "e", ["ė"]= "e", ["Ę"]= "e", ["ę"]= "e",
  ["Ě"]= "e", ["ě"]= "e", ["Ĝ"]= "g", ["ĝ"]= "g", ["Ğ"]= "g", ["ğ"]= "g", ["Ġ"]= "g", ["ġ"]= "g",
  ["Ģ"]= "g", ["ģ"]= "g", ["Ĥ"]= "h", ["ĥ"]= "h", ["Ì"]= "i", ["ì"]= "i", ["Í"]= "i", ["í"]= "i",
  ["Î"]= "i", ["î"]= "i", ["Ï"]= "i", ["ï"]= "i", ["Ĩ"]= "i", ["ĩ"]= "i", ["Ī"]= "i", ["ī"]= "i",
  ["Ĭ"]= "i", ["ĭ"]= "i", ["Į"]= "i", ["į"]= "i", ["İ"]= "i", ["ı"]= "i", ["Ĵ"]= "j", ["ĵ"]= "j",
  ["Ķ"]= "k", ["ķ"]= "k", ["Ĺ"]= "l", ["ĺ"]= "l", ["Ļ"]= "l", ["ļ"]= "l", ["Ľ"]= "l", ["ľ"]= "l",
  ["Ŀ"]= "l", ["ŀ"]= "l", ["Ł"]= "l", ["ł"]= "l", ["Ñ"]= "n", ["ñ"]= "n", ["Ń"]= "n", ["ń"]= "n",
  ["Ņ"]= "n", ["ņ"]= "n", ["Ň"]= "n", ["ň"]= "n", ["Ō"]= "o", ["ō"]= "o", ["Ŏ"]= "o", ["ŏ"]= "o",
  ["Ő"]= "o", ["ő"]= "o", ["Ô"]= "o", ["ô"]= "o", ["Ö"]= "o", ["ö"]= "o", ["Ò"]= "o", ["ò"]= "o",
  ["Ó"]= "o", ["ó"]= "o", ["Õ"]= "o", ["õ"]= "o", ["Ø"]= "o", ["ø"]= "o", ["Ŕ"]= "r", ["ŕ"]= "r",
  ["Ŗ"]= "r", ["ŗ"]= "r", ["Ř"]= "r", ["ř"]= "r", ["Ś"]= "s", ["ś"]= "s", ["Ŝ"]= "s", ["ŝ"]= "s",
  ["Ş"]= "s", ["ş"]= "s", ["Š"]= "s", ["š"]= "s", ["Ţ"]= "t", ["ţ"]= "t", ["Ť"]= "t", ["ť"]= "t",
  ["Ŧ"]= "t", ["ŧ"]= "t", ["Ù"]= "u", ["ù"]= "u", ["Ú"]= "u", ["ú"]= "u", ["Û"]= "u", ["û"]= "u",
  ["Ü"]= "u", ["ü"]= "u", ["Ũ"]= "u", ["ũ"]= "u", ["Ū"]= "u", ["ū"]= "u", ["Ŭ"]= "u", ["ŭ"]= "u",
  ["Ů"]= "u", ["ů"]= "u", ["Ű"]= "u", ["ű"]= "u", ["Ų"]= "u", ["ų"]= "u", ["Ŵ"]= "w", ["ŵ"]= "w",
  ["Ý"]= "y", ["ý"]= "y", ["Ÿ"]= "y", ["ÿ"]= "y", ["Ź"]= "z", ["ź"]= "z", ["Ż"]= "z", ["ż"]= "z",
  ["Ž"]= "z", ["ž"]= "z", ["Þ"]= "p", ["þ"]= "p", ["ß"]= "s"
}

local vogals = {"a","e","i","o","u"}

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

  list_separators_symbols = {
    [","] = true,
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
  normalize =
    function (word)
      local new_word = word:lower():gsub("qu","q"):gsub("gu","g"):gsub("ç","ss"):gsub("Ç","ss"):gsub("ão","aum")
      for accent, letter in pairs(accent_letters) do
        new_word = new_word:gsub(accent,letter)
      end
      for _, left in ipairs(vogals) do
        for _, right in ipairs(vogals) do
          new_word = new_word:gsub(left.."s"..right,left.."z"..right):gsub(left.."ch"..right,left.."x"..right)
        end
      end
      new_word = new_word:gsub("ce","sse"):gsub("ci","ssi"):gsub("de$","di"):gsub("te$","ti"):gsub("^h",""):gsub("k","c"):gsub("w","v"):gsub("oo","u")

      for _, vogal in ipairs(vogals) do
        new_word = new_word:gsub("r"..vogal.."s$","r"):gsub("z"..vogal.."z$",vogal)
      end
      return new_word
    end
  ,
}
