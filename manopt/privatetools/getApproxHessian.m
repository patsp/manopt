function [approxhess, store] = getApproxHessian(problem, x, d, store)
% Computes an approximation of the Hessian of the cost fun. at x along d.
%
% function [approxhess, store] = getApproxHessian(problem, x, d)
% function [approxhess, store] = getApproxHessian(problem, x, d, store)
%
% Returns an approximation of the Hessian at x along d of the cost function
% described in the problem structure. The cache structure store is passed
% along, possibly modified and returned in the process.
%
% If no approximate Hessian was provided, this call is redirected to
% getHessianFD.
%
% See also: getHessianFD

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


    if isfield(problem, 'approxhess')
    %% Compute the approximate Hessian using approxhess.
		
        % Check whether the approximate Hessian function wants to deal with
        % the store structure or not.
        switch nargin(problem.approxhess);
            case 2
                approxhess = problem.approxhess(x, d);
            case 3
                [approxhess, store] = problem.approxhess(x, d, store);
            otherwise
                up = MException('manopt:getApproxHessian:badapproxhess', ...
                    'approxhess should accept 2 or 3 inputs.');
                throw(up);
        end
        
    else
    %% Try to fall back to a standard FD approximation.
    
        [approxhess, store] = getHessianFD(problem, x, d, store);
        
    end
    
end
