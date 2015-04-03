function [Pd, store] = getPrecon(problem, x, d, store)
% Applies the preconditioner for the Hessian of the cost at x along d.
%
% function [Pd, store] = getPrecon(problem, x, d)
% function [Pd, store] = getPrecon(problem, x, d, store)
%
% Returns as Pd the result of applying the Hessian preconditioner to the
% tangent vector d at point x. If no preconditioner is specified, Pd = d
% (identity).
%
% See also: getHessian

% This file is part of Manopt: www.manopt.org.
% Original author: Nicolas Boumal, Dec. 30, 2012.
% Contributors: 
% Change log: 
%
%   April 2, 2015 (NB):
%       Only works with the store associated to x, not the whole storedb.

    if nargin < 4
        store = getEmptyStore();
    end
    
    if isfield(problem, 'precon')
    %% Compute the preconditioning using precon.
	
        % Check whether the precon function wants to deal with the store
        % structure or not.
        switch nargin(problem.precon)
            case 2
                Pd = problem.precon(x, d);
            case 3
                [Pd, store] = problem.precon(x, d, store);
            otherwise
                up = MException('manopt:getPrecon:badprecon', ...
                    'precon should accept 2 or 3 inputs.');
                throw(up);
        end      

    else
    %% No preconditioner provided, so just use the identity.
    
        Pd = d;
        
    end
    
end
