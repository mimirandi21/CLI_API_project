class CLI
    attr_accessor :user_name, :session, :favorite, :name

    def initialize(session = "1")
        @session = session
        run
    end

    def run
        puts ""
        puts ""
        puts "                    Greetings, friends."
        puts "                        Welcome to"
        ASCII.logo
        sleep (1)
        puts ""
        returning_prompt = TTY::Prompt.new
        returning = returning_prompt.select("Have you been to Randi's Bar before?") do |menu|
            menu.choice "Of course!", 1
            menu.choice "Nope, first time.", 2
        end

        if returning == 1
            self.returning_user
        elsif returning == 2
            user_name_prompt = TTY::Prompt.new
            @user_name = user_name_prompt.ask("What is your name?", default: "Drinky the Drunk Guy")
            puts ""
            puts "Nice to meet you #{@user_name}."
            @user_name = User.new(@user_name)
            self.get_started
        end
        
    end 
    
    def get_started
        puts ""
        puts "      Let's get a drink in your hand!"
        sleep (1)
        puts "      Searching the bar.  Just a moment."
        puts ""
        API.new.initial_fetch
        puts "      Success!"
        sleep (1)
        puts "      Let's take a look at what you can make."
        puts ""
        colorizer = Lolize::Colorizer.new
        colorizer.write "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts ""
        self.ingredient_choice
    end

    def returning_user
        
        puts ""
        user_name_prompt = TTY::Prompt.new
        @user_name = user_name_prompt.ask("What is your name?", required: true)
        @user_name = User.find_or_create_by_name(@user_name)
        puts ""
        puts "Ok, #{@user_name.name} we are all set!"
        self.next_prompt
    end

    def next_prompt
        previous_prompt = TTY::Prompt.new
        previous_response = previous_prompt.select("Would you like to choose from your favorites, make a new drink or leave?") do |menu|
            menu.choice "Choose from favorite.", 1
            menu.choice "Make a new drink.", 2
            menu.choice "Leave the bar.", 3
        end
              
            if previous_response == 1
                if @user_name.favorite != []
                    favorite_prompt = TTY::Prompt.new
                    drink = favorite_prompt.select("Choose a drink.", @user_name.favorite)
                    self.make_drink(drink)
                else
                    puts "Uh oh, you don't have any favorites."
                    puts "Let's go find you some!"
                    puts "" 
                    
                    self.get_started
                end 
            elsif previous_response == 2
                self.get_started
        
            
            elsif previous_response == 3
                puts ""
                puts "              Cheers!".light_blue
                puts ""
                sleep (1)
                puts "      Thank you for drinking with me."
                puts "      Have a great night and drive safe!"
                puts ""
                colorizer = Lolize::Colorizer.new
                colorizer.write "*************************************************************************************************"
                puts ""
                begin
                    exit
                end
            end
        
    end
    
    def again
        sleep (3)
        y_or_n_prompt = TTY::Prompt.new
        user_response = y_or_n_prompt.select("      Would you like to make another drink?") do |menu|
            menu.choice "        Hells yeah!", 1
            menu.choice "        Maybe later.", 2
        end
        
        if user_response == 1
            self.next_prompt
        else
            puts ""
            puts "              Cheers!".light_blue
            puts ""
            sleep (1)
            puts "      Thank you for drinking with me."
            puts "      Have a great night and drive safe!"
            puts ""
            colorizer = Lolize::Colorizer.new
            colorizer.write "*************************************************************************************************"
            puts ""
            begin
                exit
            end
        end
       
    end

    def ingredient_choice
        
        #asks user to pick which ingredient they want to use using ingredient list
        puts ""
        ingredient_prompt = TTY::Prompt.new
        @user_ingredient = ingredient_prompt.select("  What ingredient do you want to use?", Ingredient.ingredient_list, filter: true) 
        #     menu.default 1
        #     Ingredient.ingredient_list.each_with_index {|ingredient, index| menu.choice "ingredient", index + 1}
        # end
        puts "   You selected #{@user_ingredient}.".light_blue
        puts "   Let me search my recipe book..."
        puts ""
        API.new.drink_by_ingredient_fetch(Ingredient.find_url(@user_ingredient))
        self.drink_choice          
    end


    def drink_choice
        #asks user which drink they want to make based on ingredient choice using drink list by ingredient
        puts ""
        drink_prompt = TTY::Prompt.new
        @user_drink = drink_prompt.select("  Which of these delicious drinks would you like to make?", Drink.drink_list_by_ingredient(@user_ingredient), filter: true)
        puts "   You selected #{@user_drink}.".light_blue
        puts "   Let me grab that recipe!"
        #returns drink information based on user drink choice
        
        self.make_drink(@user_drink)  
        ASCII.small_glass 
        self.again
    end

    def make_drink(name)
        
        puts ""
        puts "  We're going to make a #{name}!"
        puts ""
        sleep (1)
        puts "   Let's get some ingredients together."
        puts ""
        colorizer = Lolize::Colorizer.new
        colorizer.write "-------------------------------------------------------------------------------------------"
        puts ""
        puts "      You are going to need: "
        puts ""
        puts Rainbow(Drink.drink_ingredient_by_name(name)).darkorchid
        
        sleep (2)
        puts "      Ok, we are ready to make our drink!"
        puts ""
        sleep (2)
        puts "  " + Rainbow(Drink.drink_instructions_by_name(name)).darkorchid
        puts ""
        colorizer.write "-------------------------------------------------------------------------------------------"
        puts ""
        sleep (2)
        puts ""
        puts "      At long last, you have a drink in your hand!"
        puts ""
        ASCII.small_glass
        favorite_prompt = TTY::Prompt.new
        favorite_response = favorite_prompt.select("Would you like to add this drink to your favorites?") do |menu|
            menu.choice "Yes, it's delicious!", 1
            menu.choice "No, thanks.", 2
        end
            if favorite_response == 1
                @user_name.add_to_favorite(name)
                self.again
            elsif favorite_response == 2
                self.again
            end
    end
end
