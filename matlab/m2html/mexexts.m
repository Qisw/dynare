function [ext, platform] = mexexts
%List of Mex files extensions
%  MEXEXTS returns a cell array containing the Mex files platform
%  dependent extensions and another cell array containing the full names
%  of the corresponding platforms.
%
%  See also MEX, MEXEXT

%  Copyright (C) 2003 Guillaume Flandin <Guillaume@artefact.tk>
%  $Revision: 1.1.2.1 $Date: 2004/03/31 14:46:22 $

ext = {'.mexsol' '.mexhpux' '.mexhp7' '.mexrs6' '.mexsg' '.mexaxp' '.mexglx' ...
	 '.mexlx' '.dll'};

platform = {'SunOS' 'HP' 'HP700' 'IBM' 'SGI' 'Alpha' 'Linux x86' 'Linux' 'Windows'};
