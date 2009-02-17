function [xparam1, estim_params_, bayestopt_, lb, ub, M_]=set_prior(estim_params_, M_, options_)
% function [xparam1,estim_params_,bayestopt_,lb,ub]=set_prior(estim_params_)
% sets prior distributions
%
% INPUTS
%    o estim_params_    [structure] characterizing parameters to be estimated.
%    o M_               [structure] characterizing the model. 
%    o options_         [structure] 
%    
% OUTPUTS
%    o xparam1          [double]    vector of parameters to be estimated (initial values)
%    o estim_params_    [structure] characterizing parameters to be estimated
%    o bayestopt_       [structure] characterizing priors
%    o lb               [double]    vector of lower bounds for the estimated parameters. 
%    o ub               [double]    vector of upper bounds for the estimated parameters.
%    o M_               [structure] characterizing the model.
%    
% SPECIAL REQUIREMENTS
%    None

% Copyright (C) 2003-2008 Dynare Team
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
  
  nvx = size(estim_params_.var_exo,1);
  nvn = size(estim_params_.var_endo,1);
  ncx = size(estim_params_.corrx,1);
  ncn = size(estim_params_.corrn,1);
  np = size(estim_params_.param_vals,1);
  
  estim_params_.nvx = nvx;
  estim_params_.nvn = nvn;
  estim_params_.ncx = ncx;
  estim_params_.ncn = ncn;
  estim_params_.np = np;
  
  xparam1 = [];
  ub = [];
  lb = [];
  bayestopt_.pshape = [];
  bayestopt_.pmean = [];
  bayestopt_.pstdev = [];
  bayestopt_.p1 = [];
  bayestopt_.p2 = [];
  bayestopt_.p3 = [];
  bayestopt_.p4 = [];
  bayestopt_.jscale = [];
  bayestopt_.name = [];
  if nvx
    xparam1 = estim_params_.var_exo(:,2);
    ub = estim_params_.var_exo(:,4); 
    lb = estim_params_.var_exo(:,3); 
    bayestopt_.pshape =  estim_params_.var_exo(:,5);
    bayestopt_.pmean =  estim_params_.var_exo(:,6);
    bayestopt_.pstdev =  estim_params_.var_exo(:,7);
    bayestopt_.p3 =  estim_params_.var_exo(:,8);
    bayestopt_.p4 =  estim_params_.var_exo(:,9);
    bayestopt_.jscale =  estim_params_.var_exo(:,10);
    bayestopt_.name = cellstr(M_.exo_names(estim_params_.var_exo(:,1),:));
  end
  if nvn
    if M_.H == 0
      nvarobs = size(options_.varobs,1);
      M_.H = zeros(nvarobs,nvarobs);
    end
    for i=1:nvn
      estim_params_.var_endo(i,1) = strmatch(deblank(M_.endo_names(estim_params_.var_endo(i,1),:)),deblank(options_.varobs),'exact');
    end
    xparam1 = [xparam1; estim_params_.var_endo(:,2)];
    ub = [ub; estim_params_.var_endo(:,4)]; 
    lb = [lb; estim_params_.var_endo(:,3)]; 
    bayestopt_.pshape = [ bayestopt_.pshape; estim_params_.var_endo(:,5)];
    bayestopt_.pmean = [ bayestopt_.pmean; estim_params_.var_endo(:,6)];
    bayestopt_.pstdev = [ bayestopt_.pstdev; estim_params_.var_endo(:,7)];
    bayestopt_.p3 = [ bayestopt_.p3; estim_params_.var_endo(:,8)];
    bayestopt_.p4 = [ bayestopt_.p4; estim_params_.var_endo(:,9)];
    bayestopt_.jscale = [ bayestopt_.jscale; estim_params_.var_endo(:,10)];
    bayestopt_.name = cellstr(strvcat(char(bayestopt_.name),...
				      M_.endo_names(estim_params_.var_endo(:,1),:)));
  end
  if ncx
    xparam1 = [xparam1; estim_params_.corrx(:,3)];
    ub = [ub; max(min(estim_params_.corrx(:,5),1),-1)];
    lb = [lb; max(min(estim_params_.corrx(:,4),1),-1)];
    bayestopt_.pshape = [ bayestopt_.pshape; estim_params_.corrx(:,6)];
    bayestopt_.pmean = [ bayestopt_.pmean; estim_params_.corrx(:,7)];
    bayestopt_.pstdev = [ bayestopt_.pstdev; estim_params_.corrx(:,8)];
    bayestopt_.p3 = [ bayestopt_.p3; estim_params_.corrx(:,9)];
    bayestopt_.p4 = [ bayestopt_.p4; estim_params_.corrx(:,10)];
    bayestopt_.jscale = [ bayestopt_.jscale; estim_params_.corrx(:,11)];
    bayestopt_.name = cellstr(strvcat(char(bayestopt_.name),...
				      char(strcat(cellstr(M_.exo_names(estim_params_.corrx(:,1),:)),...
						  ',',...
						  cellstr(M_.exo_names(estim_params_.corrx(:,2),:))))));
  end
  if ncn
    if M_.H == 0
      nvarobs = size(options_.varobs,1);
      M_.H = zeros(nvarobs,nvarobs);
    end
    xparam1 = [xparam1; estim_params_.corrn(:,3)];
    ub = [ub; max(min(estim_params_.corrn(:,5),1),-1)];
    lb = [lb; max(min(estim_params_.corrn(:,4),1),-1)];
    bayestopt_.pshape = [ bayestopt_.pshape; estim_params_.corrn(:,6)];
    bayestopt_.pmean = [ bayestopt_.pmean; estim_params_.corrn(:,7)];
    bayestopt_.pstdev = [ bayestopt_.pstdev; estim_params_.corrn(:,8)];
    bayestopt_.p3 = [ bayestopt_.p3; estim_params_.corrn(:,9)];
    bayestopt_.p4 = [ bayestopt_.p4; estim_params_.corrn(:,10)];
    bayestopt_.jscale = [ bayestopt_.jscale; estim_params_.corrn(:,11)];
    bayestopt_.name = cellstr(strvcat(char(bayestopt_.name),...
				      char(strcat(cellstr(M_.endo_names(estim_params_.corrn(:,1),:)),...
						  ',',...
						  cellstr(M_.endo_names(estim_params_.corrn(:,2),:))))));
  end
  if np
    xparam1 = [xparam1; estim_params_.param_vals(:,2)];
    ub = [ub; estim_params_.param_vals(:,4)];
    lb = [lb; estim_params_.param_vals(:,3)];
    bayestopt_.pshape = [ bayestopt_.pshape; estim_params_.param_vals(:,5)];
    bayestopt_.pmean = [ bayestopt_.pmean; estim_params_.param_vals(:,6)];
    bayestopt_.pstdev = [ bayestopt_.pstdev; estim_params_.param_vals(:,7)];
    bayestopt_.p3 = [ bayestopt_.p3; estim_params_.param_vals(:,8)];
    bayestopt_.p4 = [ bayestopt_.p4; estim_params_.param_vals(:,9)];
    bayestopt_.jscale = [ bayestopt_.jscale; estim_params_.param_vals(:, ...
						  10)];
    bayestopt_.name = cellstr(strvcat(char(bayestopt_.name),M_.param_names(estim_params_.param_vals(:,1),:)));
  end

  bayestopt_.ub = ub;
  bayestopt_.lb = lb;
  
  bayestopt_.p1 = bayestopt_.pmean;
  bayestopt_.p2 = bayestopt_.pstdev;
  
  % generalized location parameters by default for beta distribution
  k = find(bayestopt_.pshape == 1);
  k1 = find(isnan(bayestopt_.p3(k)));
  bayestopt_.p3(k(k1)) = zeros(length(k1),1);
  k1 = find(isnan(bayestopt_.p4(k)));
  bayestopt_.p4(k(k1)) = ones(length(k1),1);
  
  % generalized location parameter by default for gamma distribution
  k = find(bayestopt_.pshape == 2);
  k1 = find(isnan(bayestopt_.p3(k)));
  k2 = find(isnan(bayestopt_.p4(k)));
  bayestopt_.p3(k(k1)) = zeros(length(k1),1);
  bayestopt_.p4(k(k2)) = Inf(length(k2),1);
  
  % truncation parameters by default for normal distribution
  k = find(bayestopt_.pshape == 3);
  k1 = find(isnan(bayestopt_.p3(k)));
  bayestopt_.p3(k(k1)) = -Inf*ones(length(k1),1);
  k1 = find(isnan(bayestopt_.p4(k)));
  bayestopt_.p4(k(k1)) = Inf*ones(length(k1),1);

  % inverse gamma distribution
  k = find(bayestopt_.pshape == 4);
  for i=1:length(k)
    [bayestopt_.p1(k(i)),bayestopt_.p2(k(i))] = ...
	inverse_gamma_specification(bayestopt_.pmean(k(i)),bayestopt_.pstdev(k(i)),1);
  end
  k1 = find(isnan(bayestopt_.p3(k)));
  k2 = find(isnan(bayestopt_.p4(k)));
  bayestopt_.p3(k(k1)) = zeros(length(k1),1);
  bayestopt_.p4(k(k2)) = Inf(length(k2),1);
  
  % uniform distribution
  k = find(bayestopt_.pshape == 5);
  for i=1:length(k)
    [bayestopt_.pmean(k(i)),bayestopt_.pstdev(k(i)),bayestopt_.p1(k(i)),bayestopt_.p2(k(i))] = ...
	uniform_specification(bayestopt_.pmean(k(i)),bayestopt_.pstdev(k(i)),bayestopt_.p3(k(i)),bayestopt_.p4(k(i)));
  end
  
  % inverse gamma distribution (type 2)
  k = find(bayestopt_.pshape == 6);
  for i=1:length(k)
    [bayestopt_.p1(k(i)),bayestopt_.p2(k(i))] = ...
	inverse_gamma_specification(bayestopt_.pmean(k(i)),bayestopt_.pstdev(k(i)),2);
  end
  k1 = find(isnan(bayestopt_.p3(k)));
  k2 = find(isnan(bayestopt_.p4(k)));
  bayestopt_.p3(k(k1)) = zeros(length(k1),1);
  bayestopt_.p4(k(k2)) = Inf(length(k2),1);  
  
  k = find(isnan(xparam1));
  xparam1(k) = bayestopt_.pmean(k);