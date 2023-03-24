module TestApp
    using Toolips, ToolipsDefaults

    # welcome to your new toolips project!
    """
    home(c::Connection) -> _
    --------------------
    The home function is served as a route inside of your server by default. To
        change this, view the start method below.
    """
    function home(c::Connection)

        write!(c, p("helloworld", text = "hello world!"))
        maindiv = div("maindiv")
        chk = ToolipsDefaults.checkbox("check1", value=false)
        chk["checked"] = false
        # @show chk.fieldnames()
        push!(maindiv, chk)

        # rngsld = ToolipsDefaults.rangeslider("rngsld", 1:100)
        # push!(maindiv, rngsld)

        # :text and :children
        opt1 = ToolipsDefaults.option("1", text="Fasfsadf")  # should display values? maybe?
        opt2 = ToolipsDefaults.option("2")
        opt2[:text] = "you can also set it this way!"
        drp = ToolipsDefaults.dropdown("drop", [opt1, opt2])
        push!(maindiv, drp)

        prg = ToolipsDefaults.progress("prg")
        push!(maindiv, prg)

        write!(c, maindiv)
    end

    fourofour = route("404") do c
        write!(c, p("404message", text = "404, not found!"))
    end

    routes = [route("/", home), fourofour]
    extensions = Vector{ServerExtension}([Logger(), ])
    """
    start(IP::String, PORT::Integer, ) -> ::ToolipsServer
    --------------------
    The start function starts the WebServer.
    """
    function start(IP::String = "127.0.0.1", PORT::Integer = 8000)
        ws = WebServer(IP, PORT, routes = routes, extensions = extensions)
        ws.start(); ws
    end
end # - module
        