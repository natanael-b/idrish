local function printUsage()
  print([[

    Idris v1.1
    --------------------------------------------------------------------------------
  
    Convert natural language instructions into executable scripts
  
    Syntax:
    ~~~~~~~~
    lua5.4 idris.lua --lang=<language code> --database=<database with commands> \
      [--prefix=<prefix>] [--shell-output] [--verbose] [--help] 'input 1' 'input 2' ...
  
    Options:
    ~~~~~~~
    --lang=<language code>   =>  Specifies the language to be used.
    --database=<database>    =>  Defines the source of commands.
    --prefix=<prefix>        =>  Adds an optional prefix to commands.
    --shell-output           =>  Formats the output for shell script usage.
    --interactive            =>  Entra no modo iterativo
    --datasheet=<file>       =>  Use <file> instead datasheet.tsv
    --compile, -c            =>  Generate a database from datasheet.tsv file
    --update-idri-shell, -u  =>  Update idri-shell database (implies in --compile)
    --verbose, -v            =>  Activates verbose output.
    --debug, -d              =>  Prints de database location of each command
    --help, -h               =>  Displays this help message.
  
    Example Usage:
    ~~~~~~~~~~~~~~
    lua5.4 idris.lua --lang=pt_BR --database=demonstration \
      'create file test.txt, put the phrase Hello World in it!'

    
    ]])
  os.exit(0)
end

Language = {}
local lang,database,prefix,separator,interactive,shellOutput,debugMode,updadeIdrish = nil,nil,"","\n",false,false,false,false
local tokens,contexts,current_context,tsv_datasheet = {},{},{},"datasheet.tsv"

local function split(input)
  local words = {}
  for word in input:gmatch "[^%s]+" do
    words[#words+1] = word
  end
  return words
end

local function find(index,base,skip_recursive)
  local block = ""
  local struct = {}
  local next_index = 0

  local candidate = ""

  for i=index,#tokens do
    local token = tokens[i]
    token = Language.normalize((base == DB and candidate == "") and Language.infinitive(token:lower()) or token)

    candidate = candidate == "" and token or candidate.." "..token
    if base[candidate] then
      block = candidate
      next_index = i
      struct = base[candidate]
      break
    end
  end

  if skip_recursive then
    if block == "" and index < #tokens+1 then
      return find(index+1,base,true)
    end
  end

  if block == "" then
    return nil
  end

  return block,struct,next_index
end

local function printContexts(levels,base)
  for _,context in ipairs(base) do
    print(("  "):rep(levels)..(levels == 0 and "local db_slice_".._.." = {" or "{"))
    print(("  "):rep(levels).."  trigger = '"..context.trigger:gsub("\n","\\n"):gsub("'","\\'").."',")
    if levels == 0 then
      print(("  "):rep(levels).."  prefix = '"..(context.prefix or ''):gsub("\n","\\n"):gsub("'","\\'").."',")
    end
    print(("  "):rep(levels).."  arg = '"..context.arg:gsub("\n","\\n"):gsub("'","\\'").."',")
    print(("  "):rep(levels).."  command = '"..context.command:gsub("\n","\\n"):gsub("'","\\'").."',")
    printContexts(levels+1,context)
    print(("  "):rep(levels)..(levels == 0 and "}\n" or "},"))
  end
end

local function printOutput(levels,base,args,contextPrinted)
  contextPrinted = contextPrinted or false
  for _, context in ipairs(base) do
    if levels == 0 then
      local sub_args = {{context.arg,context.command}}
      local _prefix = context.prefix or ''
      printOutput(levels+1,context,sub_args)
      local commandOutput = ""
      if context.command:sub(-1,-1) ~= "\r" then
        for _, arg in ipairs(sub_args) do
          local command = arg[2]
          for j = 1, #sub_args, 1 do
            command = command:gsub("\0{"..j.."}",sub_args[j][1])
          end
          commandOutput = command:gsub("\0{0}",_prefix)
        end
        if debugMode then
          if contextPrinted == false then
            io.write("\n")
            printContexts(0,contexts)
            io.write("------------------------------------------------------------------------\n\n")
            contextPrinted = true
          end
          --printContexts(0,contexts,_)
          io.write("local command_".._.." = '"..commandOutput:gsub("'","\\'")..separator:gsub("\n","\\n"):gsub("'","\\'").."'\n")
          io.write((base == contexts and _ == #contexts) and "\n" or "")
          --return
        else
          io.write((commandOutput)..separator)
        end
      end
    else
      args[#args+1] = {context.arg,context.command,contextPrinted}
      printOutput(levels+1,context,args,contextPrinted)
    end
  end
end

local function goDeepLevel(control,trigger,struct,arg,subLevel)
  struct = struct or {}
  local contextReference = subLevel and current_context or contexts
  if control then
    contextReference[#contextReference+1] = {
      trigger = trigger,
      struct = struct,
      arg = arg or "",
      command = struct[0] or ""
    }
    current_context = contextReference[#contextReference]
    if current_context.struct[1] then
      local command = current_context.command
      current_context = contexts[#contexts]
      current_context.command = command..separator..current_context.command
      for l=#current_context, 1, -1 do
        table.remove(current_context,l)
      end
    end
    return true
  end
  return false
end

local function processTokens()
  local i = 1
  local _prefix = ""
  while tokens[i] ~= nil do
    local token = tokens[i]

    if current_context.trigger == nil then
      local block,struct = find(i,DB,false)
      if goDeepLevel(block,block,struct) then
        current_context.prefix = _prefix
        _prefix = ""
      else
        _prefix = _prefix == "" and token or _prefix.." "..token
      end
    else
      if Language.list_separators[token] or Language.list_separators_symbols[token:sub(-1,-1)] then
        local block,struct,next_index = find(i+1,DB,false)
        if block then
          if #token>1 and Language.list_separators_symbols[token:sub(-1,-1)] then
            token = token:sub(1,-2)
            current_context.arg = current_context.arg..(current_context.arg == "" and token or " "..token)
          end
          current_context = {}
        else
          current_context.arg = current_context.arg..(current_context.arg == "" and token or " "..token)
        end
      else

        local isPersonalPronoun = (Language.personal_pronoun[token] or Language.personal_pronoun[token:sub(1,-2)]) or false
        if isPersonalPronoun and #current_context == 0 then
          for j=#contexts-1, 1, -1 do
            if contexts[j][1] then
              local trigger = contexts[j][1].trigger
              local arg = contexts[j][1].arg
              local struct = current_context.struct[trigger]

              if goDeepLevel(struct,trigger,struct,arg,true) then
                token = nil
                break
              end
            end
          end

          if #current_context == 0 then
            local splited = split(contexts[#contexts].arg)
            for j, word in ipairs(splited) do
              word = Language.normalize(word)
              local struct = current_context.struct[word]
              if goDeepLevel(struct,word,struct,"",true) then
                for n = j+1, #splited, 1 do
                  current_context.arg = current_context.arg..splited[n]..(n == #splited and "" or " ")
                end
                contexts[#contexts].arg = ""
                break
              end
            end
          end
        end

        local isPronoun = (Language.pronouns[(token or "")] or Language.pronouns[(token or ""):sub(1,-2)]) or false
        if #current_context == 0 and isPronoun then
          local struct = current_context.struct[token]
          if goDeepLevel(struct,token,struct,"",true) then
            token = nil
          end
        end

        if isPersonalPronoun and #current_context == 0 and #(contexts[#contexts-1] or {}) > 0 and contexts[#contexts] == current_context then
          local testTrigger = contexts[#contexts-1][1].trigger
          if current_context.struct[testTrigger] then
            local struct = current_context.struct[testTrigger]
            local arg = nil
            for j=#contexts-1, 1, -1 do
              if (contexts[j][1] or {}).arg ~= "" and (contexts[j][1] or {}).arg ~= nil then
                arg = (contexts[j][1] or {}).arg
              end
            end
            if goDeepLevel(arg,testTrigger,struct,arg,true) then
              struct = current_context.struct[token]
              if goDeepLevel(struct,token,struct,"",true) then
                token = nil
              end
            end
          end
        end

        local block,struct,next_index = find(Language.pronouns[token] and i+1 or i,current_context.struct,false)
        struct = struct or {}
        if goDeepLevel(block,block,struct,"",true) then
          i = next_index or i
        else
          local arg = current_context.arg
          if token ~= "" then
            if shellOutput and token then
              token = token:gsub("'","'\"'\"'")
            end
            arg = arg..(arg == "" and (token and token or "") or (token and " "..token or ""))
          end
          current_context.arg = arg
        end
      end
    end
    i = i+1
  end
end

local function learn()
  local datasheet = io.open(tsv_datasheet,"r")
  local db = {}
  local rows = {}
  local tmpLine = ""
  local lineIsOk = false

  for line in (datasheet):lines("l") do
      tmpLine = tmpLine..line:gsub("‘","'"):gsub("’","'"):gsub('“','"'):gsub('”','"')
      local fields = {}
      for field in  tmpLine:gsub("\r",""):gmatch("[^\t]*")  do
        local doubleQuotesCount = 0
        for _ in field:gmatch('"') do
            doubleQuotesCount = doubleQuotesCount+1
        end

        lineIsOk = doubleQuotesCount%2 == 0

        if lineIsOk then
          if field:sub(1,1) == '"' and field:sub(-1,-1) == '"' then
            field = field:sub(2,-2)
          end
          fields[#fields+1] = field
          tmpLine = ""
        end
      end

      if lineIsOk then
        rows[#rows+1] = fields
      end
  end

  for _,row in ipairs(rows) do
    local input = row[1]
    local command = row[2]

    local tokens = {}
    local _prefix = nil
    for token in input:gmatch("[^%s]+") do
        if not (Language.pronouns[token] or Language.personal_pronoun[token] or Language.prepositions[token]) then
            if _prefix == nil and token:lower() == token and #tokens == 0 then
              _prefix = token
            else
              tokens[#tokens+1] = #tokens == 0 and Language.normalize(Language.infinitive(token:lower())) or token
            end
        end
    end

    local n = 1
    for i = 1, #tokens, 1 do
      if command:match(tokens[i]) then
        command = command:gsub(tokens[i],"\\0{"..tostring(i-n).."}")
        n = n+1
        tokens[i] = false
      else
        tokens[i] = Language.normalize(tokens[i])
      end
    end

    if _prefix then
      print("H")
      command = command:gsub(_prefix,"\\0{0}")
    end

    for i = #tokens, 1, -1 do
        if tokens[i] == false then
          table.remove(tokens,i)
        end
    end

    local currentStruct = {}
    for i, token in ipairs(tokens) do
      if i == 1 then
        db[token] = db[token] or {}
        currentStruct = db[token]
        if #tokens == i then
                currentStruct[0] = command:gsub("\n","\\n")
                currentStruct[1] = tostring(row[3]):lower() == "true" and true or false
        end
      else
        currentStruct[token] = currentStruct[token] or {}
        currentStruct = currentStruct[token]
        if i == #tokens then
          currentStruct[0] = command:gsub("\n","\\n")
          currentStruct[1] = tostring(row[3]):lower() == "true" and true or false
        end
      end
    end
  end

  local dbString = "DB = {\n"
  local function printDB (struct,level)
      if type(struct) == "table" then
        local padding = ("  "):rep(level)
        for key, value in pairs(struct) do
            if type(value) ~= "string" then
              if type(key) == "number" then
                dbString = dbString..(padding..'['..key..'] = '..tostring(value)..',\n')
              else
                dbString = dbString..(padding..'["'..key..'"] = {\n')
                printDB(value,level+1)
                dbString = dbString..(padding..'},\n')
              end
            else
              dbString = dbString..(padding.."[0] = \""..value:gsub("\"","\\\"").."\",\n")
            end
        end
      end
  end

  printDB(db,1)
  dbString = dbString.."}"

  print(dbString)

  local f = io.open(updadeIdrish and "databases/"..lang.."/idris-shell.lua" or "database.lua","w+b") or {}
  f:write(updadeIdrish and dbString or string.dump(load(dbString) or print,true))
end

local compileMode = false

for i = #arg, 1, -1 do
  local argument = arg[i]
  if argument == "--help" or argument == "-h" then
    printUsage()
  elseif argument:sub(1, 7) == "--lang=" then
    lang = tostring(argument):sub(8, -1)
    table.remove(arg,i)
  elseif argument:sub(1, 11) == "--database=" then
    database = tostring(argument):sub(12, -1)
    table.remove(arg,i)
  elseif argument:sub(1, 12) == "--datasheet=" then
    tsv_datasheet = argument:sub(13,-1)
    table.remove(arg,i)
  elseif argument:sub(1, 9) == "--prefix=" then
    prefix = tostring(argument):sub(10, -1)
    table.remove(arg,i)
  elseif argument == "--shell-output" then
    separator = ";\n"
    shellOutput = true
    table.remove(arg,i)
  elseif argument == "--compile" or argument == "-c" then
    compileMode = true
  elseif argument == "--update-idri-shell" or argument == "-u" then
    compileMode = true
    updadeIdrish = true
  elseif argument == "--verbose" or argument == "-v" then
    separator = ";\n"
    warn "@on"
    table.remove(arg,i)
  elseif argument == "--debug" or argument == "-d" then
    debugMode = true
    table.remove(arg,i)
  end
end

if prefix and prefix:gsub("[%s]","") ~= "" then
  table.insert(arg,prefix)
end

if #arg == 0 then
  warn "No inputs, entering in interactive mode..."
  interactive = true
  arg[#arg+1] = ""
end

if lang == nil then
  if io.open("languages/" .. (lang or "") .. ".lua","r") == nil then
    warn "Missing --lang= parameter"
    lang = os.getenv("LANG"):gsub("%.UTF%-8$","")
    if io.open("languages/" .. (lang or "") .. ".lua","r") == nil then
      lang = nil
      print "FATAL: Missing --lang= parameter and env LANG doesn't have a compatible language value"
    end
  end
end

if database == nil then
  warn "Missing --database= parameter, fallback to idris-shell"
  database = "idris-shell"
  if io.open("databases/" .. (lang or "") .. "/" .. database .. ".lua","r") == nil then
    database = nil
    print "FATAL: Missing --database= parameter and idris-shell was not found"
  end
end

if lang == nil or database == nil then
  print ""
  printUsage()
end

require("languages." .. lang)
require("databases." .. lang .. "." .. database)

if compileMode then
  learn()
end

if interactive then
  while true do
    io.write("> ")
    tokens = split(io.read("l"))
    contexts = {}
    current_context = {}

    processTokens()
    printOutput(0,contexts)
  end
else
  for _, input in ipairs(arg) do
    tokens = split(input)
    contexts = {}
    current_context = {}

    processTokens()
    printOutput(0,contexts)
  end
end
