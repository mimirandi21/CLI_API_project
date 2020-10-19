class CLI

    def run
        puts "Greetings, friends."
        puts "Let's get a drink in your hand!"
        sleep (1)
        puts "Searching the bar..."
        API.new.initial_fetch
        puts "Success!"
        sleep (1)
        puts "Let's take a look at what you can make."
        ingredient_selection
        
    end

    def ingredient_selection
        prompt = TTY::Prompt.new
        prompt.select("What ingredient do you want to use?", Ingredient.ingredient_list, filter: true)
    end
end
