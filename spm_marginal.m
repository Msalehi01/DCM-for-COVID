function [Y] = spm_marginal(X)
% Marginal densities over a multidimensional array of probabilities
% FORMAT [Y] = spm_marginal(X)
% X  - numeric array of probabilities
%
% Y  - cell array of marginals
%
% See also: spm_dot
%__________________________________________________________________________
% Copyright (C) 2020 Wellcome Centre for Human Neuroimaging

% Karl Friston
% $Id: spm_marginal.m 7894 2020-07-12 09:34:25Z karl $
# SPDX-License-Identifier: GPL-2.0

% evaluate marginals
%--------------------------------------------------------------------------
n     = ndims(X);
Y     = cell(n,1);
for i = 1:n
    j    = 1:n;
    j(i) = [];
    Y{i} = reshape(spm_sum(X,j),[],1);
end
