class API
    ingredients_list = []

    def initial_fetch
        parsed_url = URI.parse("https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list")
        response = Net::HTTP.get_response(parsed_url)
        ingredients = JSON.parse(response.body)
    
        ingredients["drinks"].each do |ingredient|
            # ingredients_list << ingredient["strIngredient1"].gsub(" ", "_")
            Ingredient.find_or_create_by_name(ingredient["strIngredient1"])
        end
    end
        
    def drink_by_ingredient_fetch(ingredient_url)
        by_ingredient_parsed_url = URI.parse(ingredient_url)
        by_ingredient_response = Net::HTTP.get_response(by_ingredient_parsed_url)
        drink_by_ingredient = JSON.parse(by_ingredient_response.body)

        drink_by_ingredient["drinks"].each do |drink|
                 
            drink_url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" + drink["idDrink"]      
            drink_parsed_url = URI.parse(drink_url)
            drink_info_response = Net::HTTP.get_response(drink_parsed_url)
            drink_info = JSON.parse(drink_info_response.body)

            drink_info["drinks"].each do |info|
                             
                ingredient_hash = {}
                
                ingredient_hash[info["strIngredient1"]] = info["strMeasure1"] if info["strMeasure1"] != "null" || nil
                ingredient_hash[info["strIngredient2"]] = info["strMeasure2"] if info["strMeasure2"] != "null" || nil
                ingredient_hash[info["strIngredient3"]] = info["strMeasure3"] if info["strMeasure3"] != "null" || nil
                ingredient_hash[info["strIngredient4"]] = info["strMeasure4"] if info["strMeasure4"] != "null" || nil
                ingredient_hash[info["strIngredient5"]] = info["strMeasure5"] if info["strMeasure5"] != "null" || nil
                ingredient_hash[info["strIngredient6"]] = info["strMeasure6"] if info["strMeasure6"] != "null" || nil
                ingredient_hash[info["strIngredient7"]] = info["strMeasure7"] if info["strMeasure7"] != "null" || nil
                ingredient_hash[info["strIngredient8"]] = info["strMeasure8"] if info["strMeasure8"] != "null" || nil
                ingredient_hash[info["strIngredient9"]] = info["strMeasure9"] if info["strMeasure9"] != "null" || nil
                ingredient_hash[info["strIngredient10"]] = info["strMeasure10"] if info["strMeasure10"] != "null" || nil
                ingredient_hash[info["strIngredient11"]] = info["strMeasure11"] if info["strMeasure11"] != "null" || nil
                ingredient_hash[info["strIngredient12"]] = info["strMeasure12"] if info["strMeasure12"] != "null" || nil
                ingredient_hash[info["strIngredient13"]] = info["strMeasure13"] if info["strMeasure13"] != "null" || nil
                ingredient_hash[info["strIngredient14"]] = info["strMeasure14"] if info["strMeasure14"] != "null" || nil
                ingredient_hash[info["strIngredient15"]] = info["strMeasure15"] if info["strMeasure15"] != "null" || nil
                

                Drink.new(drink["strDrink"], drink["idDrink"], ingredient_hash, info["strInstructions"])
            end
        end
    end
    

end
