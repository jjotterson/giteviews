'*********************************************************************************************************************************
' Code to run Git directly from Eviews
'
'  add-in user Options:
'  - repo_path   - Defaults to @datapath.  Mainly used to ensure git gui starts from right folder.
'  - log         - Show git output in Eviews log window (called git log).  Default to true.  
'  - logOptions  - specify logmode options of log window.  Default to -all logmsg, only display git log message.
'
'*********************************************************************************************************************************


'code variables ******************************************************************************************************************
'(1) current path, shell options, and set command to run in shell
%curr_path     = @datapath    'current path, if different to repo, will cd to this when using shell and then revert back
%shell_options = ""           'options passed to shell command (indicate if want table of log message, "output")
%command       =  @lower("git " + %args)  'to fix quotes inside quotes 

'(2) set default add-in options
%repo_path = @replace( @datapath, "\", "/")      'location of git repo
%log       = "true"                              'indicate if want to see log
%logOptions =  " -all logmsg"

'(2.1) override code variables 
if  @len(@option(1)) then
    if @len(@equaloption("repo_path")) then
  	    %repo_path = @replace( @equaloption("repo_path") , "\", "/")
    endif
    
    if @len(@equaloption("log")) then
        %log = @lower(@equaloption("log"))
    endif

    if @len(@equaloption("logOptions")) then
        %logOptions = @lower(@equaloption("logOptions"))
    endif       
endif


'configuration needed to display git log on eviews: ****************************************************************************
if %log == "true" then 
    logmode(name="Git output") {%logOptions}
    logclear(name="Git output")

    '(0) indicate that shell should output log table
    %shell_options = %shell_options + "output = gitTable"
    
    '(1) create a wf to store the log table produced by shell. 
    !tempErrorCountAux  = @maxerrcount + 1     
    setmaxerrs !tempErrorCountAux            'start try-catch block
    !curr_errorcount = @errorcount
    
    wfuse gitlogwf                           'try opening wf
    
    !killWf = @errorcount - !curr_errorcount 'indicate error - will need to del. wf after code run
    
    if !killWf > 0 then                      'catch
      wfcreate(wf=gitlogwf) u 1
    endif             
    
    '(2) create a page in wf to store the git log table.
    %work_page = @getnextname("gitPage")
    while @pageexist(%work_page)
        %work_page = %work_page + "0"
    wend
    pagecreate(page={%work_page}) u 1

endif


'run shell command and print log  ***********************************************************************************************
   
cd %repo_path          
    if %command <> "git gui" then                  'getting a fake error in git gui
    	  shell({%shell_options}) {%command}
    else
        !tempErrorCountAux  = @maxerrcount + 1
        setmaxerrs !tempErrorCountAux
        shell git gui                              'else could call powershell, but this won't work in mac etc
    endif
cd %curr_path

'print git message in log 
if %log == "true" then
     
    if @isobject("gitTable") then
    for !k  = 1 to @rows(gitTable)
        %git_output_line = gitTable(!k,1)
        logmsg  {%git_output_line}
    next
    endif
    
    'delete temp page or temp wf
    if !killWf > 0 then
        wfclose gitlogwf
    else
        pagedelete {%work_page}
    endif
   
endif