xopen(type = r)
  'set the working directory to run git from
  if  @len(@option(1)) then
  	  %chosenPath = @replace( @equaloption("path") , "\", "/")
      xrun setwd(%chosenPath)
  else 
      %currentDirectory = @replace( @datapath, "\", "/")
      xrun setwd(%currentDirectory)
  endif

  'run git command
  if @len(%args)>0 then
  	  %command = "git " + %args
      xrun system(tolower(%command))
  else 
      xrun system("git gui")
  endif
xclose 