'*********************************************************************************************************************************
' Code to run Git (a version control system) directly from Eviews
'
'  Options:
'  - repo_path   - when using R, will start from this path; defaults to @datapath.  Used to ensure git gui starts from right folder.
'  - log         - show git output in Eviews log window.  Default to true.  
'
'*********************************************************************************************************************************
'code variables
%curr_path = @datapath    'current path, if different to repo, will cd to this when using shell and then revert back
%shell_options = ""

'get options
%repo_path = @replace( @datapath, "\", "/")          '
%log  = "true"

if  @len(@option(1)) then
      if @len(@equaloption("repo_path")) then
  	      %repo_path = @replace( @equaloption("repo_path") , "\", "/")
      endif

      if @len(@equaloption("log")) then
          %log = @lower(@equaloption("log"))
      endif

      show %repo_path
endif

'pass this option to command:
if %log == "true" then 
    '%work_page = @getnextname("scratch")            'start workfile
    'while @pageexist(%work_page)
	'    %work_page = %work_page + "0"
    'wend
    'pagecreate(page={%work_page}) {%FREQ} {%SMPL}
    %shell_options = %shell_options + "output = junk"
endif

'get command
%command = @lower("git " + %args)
    


'run command
cd %repo_path                                  'open repo path
'run git command
if %command <> "git gui" then                  'getting a fake error in git gui
	  shell({%shell_options}) %command
else 
    !current_max = @maxerrcount
    setmaxerrs 2
    shell git gui         'else could call powershell, but then won't work in mac
    setmaxerrs !current_max
endif

cd %curr_path                                  'move back to initial path

'print git message in log
if %log == "true" then 
 logmode(name="Git output") -all error logmsg
 for !k  = 1 to @rows(junk) 
     %git_output_line = junk(!k,1)
     logmsg  %git_output_line
  next
endif