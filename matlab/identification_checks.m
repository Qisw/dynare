function [McoH, McoJ, PcoH, PcoJ, condH, condJ, eH, eJ, ind01, ind02, indnoH, indnoJ] = identification_checks(H,JJ, bayestopt_)

% Copyright (C) 2008 Dynare Team
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

% My suggestion is to have the following steps for identification check in
% dynare:

% 1. check rank of H at theta
npar = size(H,2);
indnoH = {};
indnoJ = {};
ind1 = find(vnorm(H)~=0);
H1 = H(:,ind1);
covH = H1'*H1;
sdH = sqrt(diag(covH));
sdH = sdH*sdH';
[e1,e2] = eig( (H1'*H1)./sdH );
eH = zeros(npar,npar);
% eH(ind1,:) = e1;
eH(ind1,length(find(vnorm(H)==0))+1:end) = e1;
eH(find(vnorm(H)==0),1:length(find(vnorm(H)==0)))=eye(length(find(vnorm(H)==0)));
condH = cond(H1);
% condH = cond(H1'*H1);

ind2 = find(vnorm(JJ)~=0);
JJ1 = JJ(:,ind2);
covJJ = JJ1'*JJ1;
sdJJ = sqrt(diag(covJJ));
sdJJ = sdJJ*sdJJ';
[ee1,ee2] = eig( (JJ1'*JJ1)./sdJJ );
% eJ = NaN(npar,length(ind2));
eJ = zeros(npar,npar);
eJ(ind2,length(find(vnorm(JJ)==0))+1:end) = ee1;
eJ(find(vnorm(JJ)==0),1:length(find(vnorm(JJ)==0)))=eye(length(find(vnorm(JJ)==0)));
% condJ = cond(JJ1'*JJ1);
condJ = cond(JJ1);

if rank(H)<npar
  ixno = 0;
  %         - find out which parameters are involved,
  % using something like the vnorm and the eigenvalue decomposition of H;
%   disp('Some parameters are NOT identified in the model: H rank deficient')
%   disp(' ')
  if length(ind1)<npar,
    ixno = ixno + 1;
    indnoH(ixno) = {find(~ismember([1:npar],ind1))};
%     disp('Not identified params')
%     disp(bayestopt_.name(indnoH{1}))
%     disp(' ')
  end
  e0 = find(abs(diag(e2))<eps);
  for j=1:length(e0),
    ixno = ixno + 1;
    indnoH(ixno) = {ind1(find(e1(:,e0(j))))};
%     disp('Perfectly collinear parameters')
%     disp(bayestopt_.name(indnoH{ixno}))
%     disp(' ')
  end
else % rank(H)==length(theta), go to 2
  % 2. check rank of J
%   disp('All parameters are identified at theta in the model (rank of H)')
%   disp(' ')
end

if rank(JJ)<npar
  ixno = 0;
  %         - find out which parameters are involved
%   disp('Some parameters are NOT identified by the moments included in J')
%   disp(' ')
  if length(ind2)<npar,
    ixno = ixno + 1;
    indnoJ(ixno) = {find(~ismember([1:npar],ind2))};
  end
  ee0 = find(abs(diag(ee2))<eps);
  for j=1:length(ee0),
    ixno = ixno + 1;
    indnoJ(ixno) = {ind2(find(ee1(:,ee0(j))))};
%     disp('Perfectly collinear parameters in moments J')
%     disp(bayestopt_.name(indnoJ{ixno}))
%     disp(' ')
  end
else  %rank(J)==length(theta) =>
%   disp('All parameters are identified at theta by the moments included in J')
end


% rank(H1)==size(H1,2)
% rank(JJ1)==size(JJ1,2)

% to find near linear dependence problems  I use

McoH = NaN(npar,1);
McoJ = NaN(npar,1);
for ii = 1:size(H1,2);
  McoH(ind1(ii),:) = [cosn([H1(:,ii),H1(:,find([1:1:size(H1,2)]~=ii))])];
end
for ii = 1:size(JJ1,2);
  McoJ(ind2(ii),:) = [cosn([JJ1(:,ii),JJ1(:,find([1:1:size(JJ1,2)]~=ii))])];
end

% format long  % some are nearly 1
% McoJ


% here there is no exact linear dependence, but there are several
%     near-dependencies, mostly due to strong pairwise colliniearities, which can
%     be checked using

PcoH = NaN(npar,npar);
PcoJ = NaN(npar,npar);
for ii = 1:size(H1,2);
  for jj = 1:size(H1,2);
    PcoH(ind1(ii),ind1(jj)) = [cosn([H1(:,ii),H1(:,jj)])];
  end
end

for ii = 1:size(JJ1,2);
  for jj = 1:size(JJ1,2);
    PcoJ(ind2(ii),ind2(jj)) = [cosn([JJ1(:,ii),JJ1(:,jj)])];
  end
end

ind01 = zeros(npar,1);
ind02 = zeros(npar,1);
ind01(ind1) = 1;
ind02(ind2) = 1;




