'*********************************************************************************************************************************
' Code to run Git (a version control system) directly from Eviews
'
'  Options:
'  - r_shell     - use R to access the system and run git.  Defaults to false. 
'  - repo_path   - when using R, will start from this path; defaults to @datapath.  Used to ensure git gui starts from right folder.
'  - log         - show git output in Eviews log window.  Default to true.  
'
'*********************************************************************************************************************************
'code variables
%curr_path = @datapath    'current path, if different to repo, will cd to this when using shell and then revert back
%shell_options = ""

'get options
%repo_path = @replace( @datapath, "\", "/")          '
%r_shell = "false"
%log  = "true"

if  @len(@option(1)) then
      if @len(@equaloption("repo_path")) then
  	      %repo_path = @replace( @equaloption("repo_path") , "\", "/")
      endif

      if @len(@equaloption("r_shell")) then
          %r_shell = @lower(@equaloption("r_shell"))
      endif

      if @len(@equaloption("log")) then
          %log = @lower(@equaloption("log"))
      endif

      show %repo_path
      show %r_shell
endif

'pass this option to command:
if %log == "true" then 
    %shell_options = %shell_options + "output = junk"
endif

'get command
%command = @lower("git " + %args)
    


'run command
if %r_shell == "false" then                          'run directly from Eviews, else run from R
      cd %repo_path                                  'open repo path

      'run git command
      if %command <> "git gui" then
      	  shell({%shell_options}) %command
      else 
          shell(exit = 1) powershell git gui         'using powershell just to avoid a fake error window.
      endif
      
      cd %curr_path                                  'move back to initial path



    if %log == "true" then
       logmode(name="Git output") -all error logmsg
       for !k  = 1 to @rows(junk) 
           %git_output_line = temp(!k,1)
           logmsg  %git_output_line
        next
    endif




endif







if %r_shell == "true" then       
    xopen(type = r)
      'set the working directory to run git from
      xrun setwd(%repo_path)
      
      'run git command
      xrun system(%command)
    xclose 
endif