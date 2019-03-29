%docs = ".\Docs\giteviews.pdf"
%url = "https://github.com/jjotterson/giteviews/blob/master/update_info.xml"
%version = "1.0"

' a) add-in called in via code (go straight to the add-in & extract options or default per passed-in arguments)
addin(type="global", proc="git", docs=%docs, url=%url,version={%version}, desc = "run git command line") ".\giteviews.prg"
' b) add-in called in via GUI
addin(type="global", menu="Git GUI", docs=%docs, url=%url,version={%version}, desc = "start Git GUI") ".\giteviews_gui.prg"