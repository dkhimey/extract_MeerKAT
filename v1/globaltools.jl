module GlobalTools

export get_input
# asks for input and checks validity according to lower/upper bounds
    function get_input(lower, upper)
        x = readline()
        # catches non-integer inputs
        n = try parse(Int64, x)
        catch e
            println("enter an integer! try again.")
            get_input(lower, upper)
        end
        # checks that input falls within interval
        if n < lower || n > upper
            println("out of bounds! try again.")
            get_input(lower, upper)
        else 
            return n
        end
    end

end