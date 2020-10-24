class CLI
    attr_accessor :user_name, :session, :favorite, :name

    def run
        puts ""
        puts ""
        puts "                          Greetings, friends."
        puts "                              Welcome to"
        ASCII.logo
        sleep (1)
        puts ""
        self.new_or_returning
    end 
    
    def get_started
        puts ""
        puts "     Let's get a drink in your hand!"
        puts ""
        how_to_prompt = TTY::Prompt.new
        how_to_response = how_to_prompt.select("     How would you like to search?") do |menu|
            menu.choice "      By ingredient.", 1
            menu.choice "      By name.", 2
            menu.choice "      Start over.", 3
        end

        if how_to_response == 1
            sleep (1)
            puts "     Searching the bar.  Just a moment."
            puts ""
            API.new.initial_fetch
            puts Rainbow("                   Success!").deeppink
            sleep (1)
            puts ""
            puts "     Let's take a look at what you can make."
            puts ""
            colorizer = Lolize::Colorizer.new
            colorizer.write "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            puts ""
            self.ingredient_choice
        elsif how_to_response == 2
            drink_name_prompt = TTY::Prompt.new
            drink_name = drink_name_prompt.ask("     What drink should I look for?")
            drink = API.new.search_by_drink_name(drink_name)
            if drink != nil
                make_drink(drink.name)
            else
                puts "Oops, that didn't return anything..."
                puts "Let's try again."
                self.next_prompt
            end
        elsif how_to_response == 3
            self.next_prompt
        end
    end

    def new_or_returning
        puts ""
        returning_prompt = TTY::Prompt.new
        returning = returning_prompt.select("     Have you been to Randi's Bar before?") do |menu|
            menu.choice "      Of course!", 1
            menu.choice "      Nope, first time.", 2
        end
        if returning == 1
            self.returning_user
        elsif returning == 2
            self.new_user
        end
    end

    def new_user
        user_name_prompt = TTY::Prompt.new
        @user_name = user_name_prompt.ask("     What is your name?", default: "Drinky the Drunk Guy")
        puts ""
        puts "     Nice to meet you #{@user_name}.".light_blue
        @user_name = User.new(@user_name)
        self.next_prompt
    end

    def returning_user
        puts ""
        user_name_prompt = TTY::Prompt.new
        @user_name = user_name_prompt.ask("     What is your name?", required: true)
        @user_name = User.find_or_create_by_name(@user_name)
        puts ""
        puts "     Ok, #{@user_name.name} we are all set!"
        puts ""
        self.next_prompt
    end

    def next_prompt
        puts ""
        previous_prompt = TTY::Prompt.new
        previous_response = previous_prompt.select("     Which option would you like?") do |menu|
            menu.choice "      Choose from favorite.", 1
            menu.choice "      Choose from recently made", 2
            menu.choice "      Try something new.", 3
            menu.choice "      Create your own drink", 4
            menu.choice "      Leave the bar.", 5
        end
        
        if previous_response == 1
            if @user_name.favorite != []
                puts ""
                colorizer = Lolize::Colorizer.new
                colorizer.write "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                puts ""
                favorite_prompt = TTY::Prompt.new
                drink = favorite_prompt.select("     Choose a drink.", @user_name.favorite + ["Start over"])
                if drink == "Start over"
                    self.next_prompt
                else
                    self.make_drink(drink)
                end
            else
                puts "     Uh oh, you don't have any favorites."
                puts "     Let's go find you some!"
                puts "" 
                self.get_started
            end 
        elsif previous_response == 2
            puts ""
            recent_prompt = TTY::Prompt.new
            recent_drink = recent_prompt.select("     Which of these would you like to try?", Drink.recently_made.uniq + ["Start over"], filter: true)
            if recent_drink == "Start over"
                self.next_prompt
            else
                self.make_drink(recent_drink)
            end
        elsif previous_response == 3
            self.get_started
        elsif previous_response == 4
            self.create_a_drink
        elsif previous_response == 5
            self.another
        end
    end
    
    def again
        sleep (1)
        puts ""
        y_or_n_prompt = TTY::Prompt.new
        user_response = y_or_n_prompt.select("     You still thirsty?") do |menu|
            menu.choice "      Hells yeah!", 1
            menu.choice "      Not right now.", 2
        end
        
        if user_response == 1
            self.next_prompt
        else
            self.another
        end
    end

    def ingredient_choice
        #asks user to pick which ingredient they want to use using ingredient list
        puts ""
        ingredient_prompt = TTY::Prompt.new
        @user_ingredient = ingredient_prompt.select("     What ingredient do you want to use?", Ingredient.ingredient_list + ["Start over"], filter: true) 
        if @user_ingredient == "Start over"
            self.next_prompt
        else
            puts "     You selected #{@user_ingredient}.".light_blue
            puts ""
            puts "     Let me search my recipe book..."
            puts ""
            API.new.drink_by_ingredient_fetch(Ingredient.find_url(@user_ingredient))
            self.drink_choice  
        end        
    end


    def drink_choice
        #asks user which drink they want to make based on ingredient choice using drink list by ingredient
        puts ""
        drink_prompt = TTY::Prompt.new
        @user_drink = drink_prompt.select("     Which of these delicious drinks would you like to make?", Drink.drink_list_by_ingredient(@user_ingredient) + ["Start over"], filter: true)
        if @user_drink == "Start over"
            self.next_prompt
        else
            puts "     You selected #{@user_drink}.".light_blue
            puts ""
            puts "     Let me grab that recipe!"
            #returns drink information based on user drink choice
            self.make_drink(@user_drink)  
            ASCII.small_glass 
            self.again
        end
    end

    def make_drink(name)
        puts ""
        puts "     We're going to make a #{name}!"
        sleep (1)
        puts "     Let's get some ingredients together."
        puts ""
        colorizer = Lolize::Colorizer.new
        colorizer.write "-----------------------------------------------------------------------------------------------------"
        puts ""
        puts "      You are going to need: "
        puts ""
        puts Rainbow(Drink.drink_ingredient_by_name(name)).darkorchid
        sleep (1)
        puts ""
        puts "      Ok, we are ready to make our drink!"
        puts ""
        sleep (1)
        puts "  " + Rainbow(Drink.drink_instructions_by_name(name)).darkorchid
        puts ""
        colorizer.write "----------------------------------------------------------------------------------------------------"
        puts ""
        sleep (1)
        puts ""
        puts "      At long last, you have a drink in your hand!"
        puts Rainbow("               Cheers!").deeppink 
        puts ""
        ASCII.small_glass
        favorite_prompt = TTY::Prompt.new
        favorite_response = favorite_prompt.select("     Would you like to add this drink to your favorites?") do |menu|
            menu.choice "      Yes, it's delicious!", 1
            menu.choice "      No, thanks.", 2
            puts ""
        end

        if favorite_response == 1
            @user_name.add_to_favorite(name)
            self.again
        elsif favorite_response == 2
            self.again
        end
    end

    def another
        puts ""
        another_prompt = TTY::Prompt.new
        another_response = another_prompt.select("     Is there anyone else in your party who needs a drink?") do |menu|
            menu.choice "      Yes, absolutely!", 1
            menu.choice "      Nope, we're all set.", 2
        end

        if another_response == 1
            puts ""
            colorizer = Lolize::Colorizer.new
            colorizer.write "*************************************************************************************************"
            puts ""
            self.new_or_returning
        elsif another_response == 2
            puts ""
            sure_prompt = TTY::Prompt.new
            sure_response = sure_prompt.select("     Are you sure you want to leave?  All favorites will be lost.") do |menu|
                menu.choice "      Yep, we're heading home for the night.", 1
                menu.choice "      No, we love it here!", 2
            end

            if sure_response == 1
                self.goodbye
            elsif sure_response == 2
                self.new_or_returning
            end
        end
    end

    def goodbye
        puts ""
        puts Rainbow("                           Cheers!").deeppink
        puts ""
        sleep (1)
        puts "                 Thank you for drinking with me."
        puts "                Have a great night and drive safe!"
        puts ""
        colorizer = Lolize::Colorizer.new
        colorizer.write "*************************************************************************************************"
        puts ""
        begin
            exit
        end
    end 

    def create_a_drink
        puts ""
        new_name_prompt = TTY::Prompt.new
        new_name_response = new_name_prompt.ask("     What is the name of your drink?") do |q|
            q.required true
            q.modify :capitalize
        end
        new_ingredient_hash = {}
        puts ""
        ingredient_1_prompt = TTY::Prompt.new
        new_ingredient = ingredient_1_prompt.ask("     What do we need to use?") do |q|
            q.required true
            q.modify :capitalize
        end
        amount_1_prompt = TTY::Prompt.new
        amount_response = amount_1_prompt.ask("     How much do we need?") do |q|
        end
        puts ""
        new_ingredient_hash[new_ingredient] = amount_response
        more_prompt = TTY::Prompt.new
        more_response = more_prompt.select("     Do we need any more ingredients?") do |menu|
            menu.choice "      Yep.", 1
            menu.choice "      Nope.", 2
        end

        
        until more_response == 2
            puts ""
            ingredient_prompt = TTY::Prompt.new
            ingredient_response = ingredient_prompt.ask("     What do we need to use?") do |q|
                q.required true
                q.modify :capitalize
            end
            amount_prompt = TTY::Prompt.new
            amount_response = amount_prompt.ask("     How much do we need?") do |q|
            end
            puts ""
            new_ingredient_hash[ingredient_response] = amount_response
            more_prompt = TTY::Prompt.new
            more_response = more_prompt.select("     Do we need any more ingredients?") do |menu|
                menu.choice "      Yep.", 1
                menu.choice "      Nope.", 2 
            end
        end
        if more_response == 2
            puts ""
            new_recipe_prompt = TTY::Prompt.new
            new_recipe_response = new_recipe_prompt.ask("     How do we put this drink together?") do |q|
                q.required true
                q.modify :capitalize
            end
            puts ""
            puts "     Ok, let me whip this up for you!"
            puts ""
            colorizer = Lolize::Colorizer.new
            colorizer.write "*************************************************************************************************"
            puts ""
        end
        new_url = "unknown"
        new_drink = Drink.new(new_name_response, new_url, new_ingredient_hash, new_recipe_response)
        self.make_drink(new_drink.name)
    end
end
