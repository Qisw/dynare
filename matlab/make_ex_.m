% Copyright (C) 2001 Michel Juillard
%
function make_ex_
  global M_ options_ oo_ ex0_ 
  
  options_ = set_default_option(options_,'periods',0);
  
  if isempty(oo_.exo_steady_state)
    oo_.exo_steady_state = zeros(M_.exo_nbr,1);
  end
  if isempty(oo_.exo_simul)
    if isempty(ex0_)
      oo_.exo_simul = [ones(M_.maximum_lag+options_.periods+M_.maximum_lead,1)*oo_.exo_steady_state'];
    else
      oo_.exo_simul = [ones(M_.maximum_lag,1)*ex0_';ones(options_.periods+M_.maximum_lead,1)*oo_.exo_steady_state'];
    end
  elseif size(oo_.exo_simul,2) < length(oo_.exo_steady_state)
    k = size(oo_.exo_simul,2)+1:length(oo_.exo_steady_state);
    if isempty(ex0_)
      oo_.exo_simul = [oo_.exo_simul ones(M_.maximum_lag+size(oo_.exo_simul,1)+M_.maximum_lead,1)*oo_.exo_steady_state(k)'];
    else
      oo_.exo_simul = [oo_.exo_simul [ones(M_.maximum_lag,1)*ex0_(k)'; ones(size(oo_.exo_simul,1)-M_.maximum_lag+M_.maximum_lead, ...
						1)*oo_.exo_steady_state(k)']];
    end
  elseif size(oo_.exo_simul,1) < M_.maximum_lag+M_.maximum_lead+options_.periods
    if isempty(ex0_)
      oo_.exo_simul = [oo_.exo_simul; ones(M_.maximum_lag+options_.periods+M_.maximum_lead-size(oo_.exo_simul,1),1)*oo_.exo_steady_state'];
    else
      oo_.exo_simul = [ones(M_.maximum_lag,1)*ex0_'; oo_.exo_simul; ones(options_.periods+M_.maximum_lead-size(oo_.exo_simul, ...
						  1),1)*oo_.exo_steady_state'];
    end
  end
    
	     