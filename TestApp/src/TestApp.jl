module TestApp
    using Toolips, ToolipsDefaults, ToolipsSession

    mutable struct Model
        v::Int64
    end

    function update(m::Model)
        m.v+=1
    end
    mod = Model(1)

    function startmodel(m::Model)
        Threads.@spawn begin
            while true
                update(m)
                sleep(1)
            end
        end
    end




    # welcome to your new toolips project!
    """
    home(c::Connection) -> _
    --------------------
    The home function is served as a route inside of your server by default. To
        change this, view the start method below.
    """
    function home(c::Connection)
        mainstyle = ("border-style" => "solid", "border-width" => 8px, "border-radius" => 8px, "padding" => 8px, "margin" => 8px, "border-color" => "white")

        bod = body("mybody")
        
        maindiv = div("maindiv")
        push!(bod, maindiv)

        push!(maindiv, h("helloworld", text = "hello world!" * string(mod.v), align = "center")) # align works!!
        chk = ToolipsDefaults.checkbox("check1", value=false)
        chk["checked"] = false
        # @show chk.fieldnames()
        push!(maindiv, chk)

        # rngsld = ToolipsDefaults.rangeslider("rngsld", 1:100)
        # push!(maindiv, rngsld)

        # :text and :children
        drp_div = div("drp_div")
        push!(maindiv, drp_div)
        style!(drp_div, mainstyle...)
        opt1 = ToolipsDefaults.option("1", text="Fasfsadf")  # should display values? maybe?
        opt2 = ToolipsDefaults.option("2")
        opt2[:text] = "you can also set it this way!"
        drp = ToolipsDefaults.dropdown("drop", [opt1, opt2])
        style!(drp, mainstyle...)
        push!(drp_div, drp)

        style!(bod, mainstyle..., "background-color" => "#5577ff", )
        
        
        write!(c, bod)

        # write!(c, maindiv)
    end

    fourofour = route("404") do c
        write!(c, p("404message", text = "404, not found!"))
    end

    routes = [route("/", home), fourofour]
    extensions = Vector{ServerExtension}([Logger(), Session()])
    """
    start(IP::String, PORT::Integer, ) -> ::ToolipsServer
    --------------------
    The start function starts the WebServer.
    """
    function start(IP::String = "127.0.0.1", PORT::Integer = 8000)
        ws = WebServer(IP, PORT, routes = routes, extensions = extensions)
        ws.start(); ws
        startmodel(mod)
    end
end # - module
        