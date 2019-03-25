'get options
%repo_path = @replace( @datapath, "\", "/")
%r_shell = "false"

if  @len(@option(1)) then
      if @len(@equaloption("repo_path")) then
  	      %repo_path = @replace( @equaloption("repo_path") , "\", "/")
      endif

      if @len(@equaloption("r_shell")) then
          %r_shell = @lower(@equaloption("r_shell"))
      endif

      show %repo_path
      show %r_shell
endif

'get command
%command = @lower("git " + %args)
    

if %r_shell == "false" then                          'run directly from Eviews, else run from R
      'run git command
      if %command <> "git gui" then
      	  shell %command
      else 
          shell(exit = 1) powershell git gui         'using powershell just to avoid a fake error window.
      endif
else
    xopen(type = r)
      'set the working directory to run git from
      xrun setwd(%repo_path)
      
      'run git command
      xrun system(%command)
    xclose 
endif