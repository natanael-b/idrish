#!/bin/lua5.4

do
    local lang,database,prefix

    for i,argument in ipairs (arg) do
      if lang == nil and tostring(argument):sub(1,7) == "--lang=" then
        lang = tostring(argument):sub(8,-1)
        arg[i] = false
        goto _continue
      end

      if database == nil and tostring(argument):sub(1,11) == "--database=" then
        database = tostring(argument):sub(12,-1)
        arg[i] = false
        goto _continue
      end

      if prefix == nil and tostring(argument):sub(1,9) == "--prefix=" then
        prefix = tostring(argument):sub(10,-1)
        arg[i] = false
        goto _continue
      end
      ::_continue::
    end

    require("languages."..lang)
    require("databases."..lang.."."..database)
end

Words = {}

function Split(input)
    Words = {}

    for word in tostring(input):gmatch("[^ ]*") do
        word = word == "" and " " or word
    
        if word:sub(-1,-1) == "," then
            word = word:sub(1,-2)
            Words[#Words+1] = word
            Words[#Words+1] = ","
        else
            Words[#Words+1] = word
        end
    end
end

function Find_DB_key(current_index,list)
    if list == nil then return nil end

    local avaialable_nouns= {}

    for noun in pairs(list) do
        if type(noun) == "string" then
            local _,spaces_count = noun:gsub(" ","")
            avaialable_nouns[spaces_count] = avaialable_nouns[spaces_count] or {}
            avaialable_nouns[spaces_count][#avaialable_nouns[spaces_count]+1] = noun

            avaialable_nouns.max_spaces = avaialable_nouns.max_spaces or 0
            avaialable_nouns.max_spaces = avaialable_nouns.max_spaces > spaces_count and avaialable_nouns.max_spaces or spaces_count
        end
    end


    for i = (avaialable_nouns.max_spaces or -1), 1, -1 do
        for _, noun in ipairs(avaialable_nouns[i]) do
            local words_combined = Words[current_index]
            for _ = 1, i, 1 do
                words_combined = words_combined.." "..(Words[current_index+1] or "")
            end

            if noun == words_combined then
                for _ = 1, i, 1 do
                    Words[current_index+1] = false
                end

                return list[words_combined]
            end
        end
    end

    return nil
end

State = {}
for i, input in ipairs(arg) do
    if input == false then goto skip_input end

    Split((prefix or "")..input.." \0")
    local current_list = {}
    local current_fallback = {}

    for _, word in ipairs(Words) do
        if word == false then goto continue end

        ::start::
        if State.verb == nil then
            Words[_] = Language.infinitive(word:lower())

            State.verb = Find_DB_key(_,DB) or DB[Words[_]]
            
            if State.verb then
                State.arguments = State.arguments or {}
                State.arguments_fallback = State.arguments_fallback or {}

                State.arguments[1] = {}
                State.arguments_fallback[1] = State.arguments_fallback[1] or {}

                State.current_list_index = 1

                current_list = State.arguments[1]
                current_fallback = State.arguments_fallback[1]
            end
            goto continue
        end

        if State.noun == nil then
            State.noun = Find_DB_key(_,State.verb) or State.verb[word]

            if State.noun then
                if Language.prepositions[current_list[#current_list]] then
                    table.remove(current_list,#current_list)
                end

                State.old_noun_word = State.noun_word
                State.noun_word = word

                State.arguments[2] = {}
                State.arguments_fallback[2] = State.arguments_fallback[2] or {}

                State.current_list_index = 2

                current_list = State.arguments[2]
                current_fallback = State.arguments_fallback[2]
                goto continue
            end
        end

        if word == "\0" or (Language.list_separators[word] and DB[Language.infinitive(Words[_+1]:lower())]) then
            if State.noun == nil and (Language.prepositions[State.arguments[1][1]] or Language.pronouns[State.arguments[1][1]]) then
                table.remove(State.arguments[1],1)
            end

            local argument_1 = table.concat(State.arguments[1] or {}," ")
            local argument_2 = table.concat(State.arguments[2] or {}," ")
            local argument_3 = table.concat(State.arguments[3] or {}," ")

            if State.current_list_index == 2 and #(State.arguments[2] or {}) == 0 then
                argument_2 = argument_1
            end

            if #(State.arguments[2] or {}) == 0 then
                argument_2 = table.concat(State.arguments_fallback[2] or {}," ")
            end

            if #(State.arguments[3] or {}) == 0 then
                argument_3 = table.concat(State.arguments_fallback[3] or {}," ")
            end

            if (#(State.arguments[2] or {}) == 0) and State.old_noun_word ~= State.noun_word and #(State.arguments[1] or {}) ~= 0 then
                argument_2 = argument_1
                goto build_cmd
            end

            if (#(State.arguments[2] or {}) == 0) and State.old_noun_word ~= State.noun_word and #(State.arguments[3] or {}) ~= 0 then
                argument_2 = argument_3
            end

            ::build_cmd::

            local cmd = tostring((State.noun or State.verb)[0])
            cmd = cmd:gsub("\0{1}",argument_1):gsub("\0{2}",argument_2):gsub("\0{3}",argument_3)

            print(cmd)

            State.noun = nil
            State.verb = nil

            if word == "\0" then
                State = {}
            end

            goto continue
        end

        if Language.personal_pronoun[word] then
            word = State.noun_word
            goto start
        end

        if State.noun then
            local sub_noun = Find_DB_key(_,State.noun) or State.noun[word]

            if sub_noun then
                State.noun = sub_noun

                State.arguments[3] = {}
                State.current_list_index = 3
                State.arguments_fallback[3] = State.arguments_fallback[3] or {}

                current_list = State.arguments[3]
                current_fallback = State.arguments_fallback[3]
                goto continue
            end

            if State.noun[Words[_+1]] and (Language.prepositions[word] or Language.pronouns[word]) then
                goto continue
            end
        end

        if State.verb[Words[_+1]] and (Language.prepositions[word] or Language.pronouns[word]) then
            goto continue
        end

        current_list[#current_list+1] = word
        current_fallback[#current_fallback+1] = word
        ::continue::
    end
    ::skip_input::
end
