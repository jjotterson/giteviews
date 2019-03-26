'*********************************************************************************************************************************
' Code to open Git GUI from Eviews add-in menu
'
'  git will open from current path  (to change it, use: cd new_path)
'
'*********************************************************************************************************************************
!tempErrorCountAux  = @maxerrcount + 1     'get unwanted error; in windows can use powershell to avoid this.
setmaxerrs !tempErrorCountAux
shell git gui                             