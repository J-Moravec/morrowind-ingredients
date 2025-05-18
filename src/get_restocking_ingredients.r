library("XML")

get_restocking_merchants = function(){
    url = "https://en.uesp.net/wiki/Morrowind:Restocking_Alchemy_Merchants"
    html = readLines(url, warn = FALSE)
    table = XML::readHTMLTable(html, stringsAsFactors = FALSE)[[1]]

    # First row is a table header, we don't need it
    table = table[-1,]

    # First column contains merchant, their location, and gold, separated by newline
    #  - we need both name and location
    #  - Superscript TR seems to conflicts with XML parsing, need to fix Galsa Andrano
    #  - Also remove [sic], since its annoying
    merchant_location = table[[1]]
    merchant_location =
        sub("Galsa AndranoTRMournhold", "Galsa Andrano\nMournhold", merchant_location)
    merchant_location = sub("[sic] ", "", merchant_location, fixed = TRUE)
    merchant_location = strsplit(merchant_location, "\n", fixed = TRUE) |> do.call(what = rbind)
    merchant_location = merchant_location[, 1:2] |>
        as.data.frame() |>
        setNames(c("merchant", "location"))

    # Second column contains newline separated ingredients and their count
    # - we want to transform this into a long format
    # - split the ingredient and count
    # - and then merge with merchant and their location
    ingredient = table[[2]]
    ingredient = strsplit(ingredient, "\n", fixed = TRUE) |>
        setNames(merchant_location$merchant) |>
        stack() |>
        setNames(c("ingredient", "merchant"))
    ingredient[["count"]] = sub(".*\\(([0-9]+)\\)", "\\1", ingredient[["ingredient"]])
    ingredient[["ingredient"]] = sub(" \\([0-9]+\\)", "", ingredient[["ingredient"]])
    merchant_location_ingredient = merge(merchant_location, ingredient)

    # Third column is recipes, it is unimportant to us.

    merchant_location_ingredient
    }


get_ingredient_effects = function(){
    url = "https://en.uesp.net/wiki/Morrowind:Ingredients"
    html = readLines(url, warn = FALSE)

    # This unfortunately removes a lot of newlines that delimited items within columns
    # We will need to fix every column of interest
    table = XML::readHTMLTable(html, stringsAsFactors = FALSE)[[1]]

    # First row is a table header, we don't need it
    table = table[-1,]

    # Names are in 1th column
    # we remove everything after "ingred" or "food"
    ingredient = sub("(ingred|food).*", "", table[[1]])

    # Effects are in 3th column
    # We add newlines between each non-capital and capital letter
    effects = gsub("([a-z])([A-Z])", "\\1\n\\2", table[[3]])

    # We don't need effecs in different columns or long format (so far)
    effects = gsub("\n", ", ", effects)

    data.frame(
        "ingredient" = ingredient,
        "effect" = effects,
        "weight" = table[[5]],
        "value" = table[[4]]
        )
    }


get_restocking_ingredients = function(){
    merchants = get_restocking_merchants()
    ingredients = get_ingredient_effects()
    merge(merchants, ingredients)
    }
