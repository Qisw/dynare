function [cs, irf_shocks_indx, irf_names, titles, titTeX]=get_IRF_shock_sizes_and_indices(M_,options_)
% function  [cs, irf_shocks_indx, irf_names, titles, titTeX]=get_IRF_shock_sizes_and_indices(M_,options_)
% gets shock sizes for IRFS 
%
% INPUTS
%   M_:                 Matlab's structure describing the Model (initialized by dynare, see @ref{M_}).
%   options_:           Matlab's structure describing the options (initialized by dynare, see @ref{options_}).
%
% OUTPUTS
%   cs:                 matrix with IRF shocks in columns
%   irf_shocks_indx:    indices of shock vectors in cs
%   irf_names:          names for title and saving
%   titles:             figure titles
%   titTeX:             titles for LaTeX
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2013 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

if ~isempty(options_.irf_opt.irf_shocks) %if shock size specified
    if options_.irf_opt.stderr_multiples  % if specified in terms of standard deviations
        if options_.irf_opt.nonorthogonal %if no orthogonalization
            if options_.irf_opt.generalized_irf
                SS(M_.exo_names_orig_ord,M_.exo_names_orig_ord)=M_.Sigma_e+1e-14*eye(M_.exo_nbr);
                cs=transpose(chol(SS))\(diag(sqrt(diag(M_.Sigma_e)))*options_.irf_opt.irf_shocks);   %already in standard deviations
            else
                cs=diag(sqrt(diag(M_.Sigma_e)))*options_.irf_opt.irf_shocks;
            end
        else %orthogonalization
            if options_.irf_opt.generalized_irf %already in standard deviations, use correlation matrix
                cs = options_.irf_opt.irf_shocks;       
            else
                SS(M_.exo_names_orig_ord,M_.exo_names_orig_ord)=M_.Sigma_e+1e-14*eye(M_.exo_nbr);
                cs = transpose(chol(SS));
                cs = cs*options_.irf_opt.irf_shocks; 
            end
        end        
    else % if specified in absolute terms       
        if options_.irf_opt.nonorthogonal %if no orthogonalization
            if options_.irf_opt.generalized_irf %bring into in standard deviations
                cs = transpose(chol(M_.Sigma_e+1e-14*eye(M_.exo_nbr)));                
                cs = cs\options_.irf_opt.irf_shocks;
            else
                cs=options_.irf_opt.irf_shocks;
            end
        else %orthogonalization        
            if options_.irf_opt.generalized_irf %bring into in standard deviations
                cs = diag(sqrt(diag(M_.Sigma_e)))\options_.irf_opt.irf_shocks;
            else
                cs = transpose(chol(M_.Sigma_e+1e-14*eye(M_.exo_nbr)));                
                cs = cs*(diag(sqrt(diag(M_.Sigma_e)))\options_.irf_opt.irf_shocks);
            end
        end
    end
    n_irfs=size(cs,2);
    irf_shocks_indx = (1:n_irfs);
    % set the titles
    if isempty(options_.irf_opt.irf_shock_graphtitles)
        irf_names='shock_vec_1';
        titles='shock_vec_1';
        for ii=1:n_irfs
            irf_names = char(irf_names, ['shock_vec_',num2str(ii+1)]);
            titles = char(titles, ['shock_vec_',num2str(ii+1)]);
        end
        if options_.TeX
            titTeX(M_.exo_names_orig_ord,:) = M_.exo_names_tex; %to be fixed
        else
            titTeX=[];
        end
    else
%         for ii=1:n_irfs
%             if regexp(fname, '[/\*:?"<>|]', 'once')
% 
%             end
%           end
        if size(options_.irf_opt.irf_shock_graphtitles,1)~=n_irfs
            error('Number of Titles and number of irfs do not match');
        end
        irf_names=options_.irf_opt.irf_shock_graphtitles;
        titles=options_.irf_opt.irf_shock_graphtitles;
        if options_.TeX
            titTeX(M_.exo_names_orig_ord,:) = M_.exo_names_tex; %to be fixed
        else
            titTeX=[];
        end       
    end   
else  %if shock size not specified  
    if options_.irf_opt.generalized_irf %bring into in standard deviations
        SS(M_.exo_names_orig_ord,M_.exo_names_orig_ord)=M_.Sigma_e+1e-14*eye(M_.exo_nbr);
        cs = transpose(chol(SS))\transpose(chol(SS));
    else
        SS(M_.exo_names_orig_ord,M_.exo_names_orig_ord)=M_.Sigma_e+1e-14*eye(M_.exo_nbr);
        cs = transpose(chol(SS));
    end
    if options_.irf_opt.nonorthogonal %if no orthogonalization
      fprintf('\nNon-orthogonalized IRFs only supported for user specified shocks.\n')
    end
    irf_shocks_indx = getIrfShocksIndx();
    irf_names=M_.exo_names;
    titles =M_.exo_names ;
    if options_.TeX
        titTeX(M_.exo_names_orig_ord,:) = M_.exo_names_tex; %to be fixed
    else
        titTeX=[];
    end
end
   
end
