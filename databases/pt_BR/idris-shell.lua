DB = {
    ["criar"] = {
        [0] = "echo 'criar o que?'",
        ["arquivo"] = {
            [0] = "echo -n > '\0{2}'"
        },
        ["diretório"] = {
            [0] = "mkdir -p '\0{1}'"
        },
        ["pasta"] = {
            [0] = "mkdir '\0{1}'"
        }
    },
    ["colocar"] = {
        ["arquivo"] = {
            ["frase"] = {
                [0] = "echo -n '\0{3}' >> '\0{2}'"
            },
            ["texto"] = {
                [0] = "echo -n '\0{3}' >> '\0{2}'"
            }
        }
    },
    ["mover"] = {
        ["arquivo"] = {
            ["para"] = {
                [0] = "mv '\0{2}' '\0{3}'"
            }
        }
    },
    ["apagar"] = {
        ["arquivo"] = {
            [0] = "rm '\0{2}'"
        },
        ["pasta"] = {
            [0] = "rm -rf '\0{2}'"
        },
        ["diretório"] = {
            [0] = "rm -rf '\0{2}'"
        },
    },
    ["abrir"] = {
        [0] = "'\0{1}' '\0{2}'",
    }
}
