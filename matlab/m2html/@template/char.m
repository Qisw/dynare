function s = char(tpl)
%TEMPLATE Convert a template object in a one line description string
%  S = CHAR(TPL) is a class convertor from Template to a string, used
%  in online display.
%  
%  See also DISPLAY

%  Copyright (C) 2003 Guillaume Flandin <Guillaume@artefact.tk>
%  $Revision: 1.1.2.1 $Date: 2004/03/31 14:53:56 $

s = ['Template Object: root ''',...
		tpl.root,''', ',...
		num2str(length(tpl.file)), ' files, ',...
		num2str(length(tpl.varkeys)), ' keys, ',...
		tpl.unknowns, ' unknowns.'];
