using Pkg; Pkg.activate(".")
using Toolips
using TestApp

IP = "127.0.0.1"
PORT = 8000
TestAppServer = TestApp.start(IP, PORT)
