function [hess, store] = getHessian(problem, x, d, store)
% Computes the Hessian of the cost function at x along d.
%
% function [hess, store] = getHessian(problem, x, d)
% function [hess, store] = getHessian(problem, x, d, store)
%
% Returns the Hessian at x along d of the cost function described in the
% problem structure. The cache structure store is passed along, possibly
% modified and returned in the process.
%
% If an exact Hessian is not provided, an approximate Hessian is returned
% if possible, without warning. If not possible, an exception will be
% thrown. To check whether an exact Hessian is available or not (typically
% to issue a warning if not), use canGetHessian.
%
% See also: getPrecon getApproxHessian canGetHessian

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
    
    if isfield(problem, 'hess')
    %% Compute the Hessian using hess.
	
        % Check whether the hess function wants to deal with the store
        % structure or not.
        switch nargin(problem.hess)
            case 2
                hess = problem.hess(x, d);
            case 3
                [hess, store] = problem.hess(x, d, store);
            otherwise
                up = MException('manopt:getHessian:badhess', ...
                    'hess should accept 2 or 3 inputs.');
                throw(up);
        end
    
    elseif isfield(problem, 'ehess') && canGetEuclideanGradient(problem)
    %% Compute the Hessian using ehess.
    
        % We will need the Euclidean gradient for the conversion from the
        % Euclidean Hessian to the Riemannian Hessian.
        [egrad, store] = getEuclideanGradient(problem, x, store);
		
        % Check whether the ehess function wants to deal with the store
        % structure or not.
        switch nargin(problem.ehess)
            case 2
                ehess = problem.ehess(x, d);
            case 3
                [ehess, store] = problem.ehess(x, d, store);
            otherwise
                up = MException('manopt:getHessian:badehess', ...
                    'ehess should accept 2 or 3 inputs.');
                throw(up);
        end
        
        % Convert to the Riemannian Hessian
        hess = problem.M.ehess2rhess(x, egrad, ehess, d);
        
    else
    %% Attempt the computation of an approximation of the Hessian.
        
        [hess, store] = getApproxHessian(problem, x, d, store);
        
    end
    
end
