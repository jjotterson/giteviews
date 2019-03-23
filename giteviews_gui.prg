xopen(type = r)
  %currentDirectory = @replace( @datapath, "\", "/")
  xrun setwd(%currentDirectory)
  xrun system("git gui")
xclose 