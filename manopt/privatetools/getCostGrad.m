function [cost, grad, store] = getCostGrad(problem, x, store)
% Computes the cost function and the gradient at x in one call if possible.
%
% function [cost, store] = getCostGrad(problem, x)
% function [cost, store] = getCostGrad(problem, x, store)
%
% Returns the value at x of the cost function described in the problem
% structure, as well as the gradient at x. The cache struct store is
% passed along, possibly modified and returned in the process.
%
% See also: canGetCost canGetGradient getCost getGradient

% This file is part of Manopt: www.manopt.org.
% Original author: Nicolas Boumal, Dec. 30, 2012.
% Contributors: 
% Change log: 
%
%   April 2, 2015 (NB):
%       Only works with the store associated to x, not the whole storedb.

    if nargin < 3
        store = getEmptyStore();
    end


    if isfield(problem, 'costgrad')
    %% Compute the cost/grad pair using costgrad.
	
        % Check whether the costgrad function wants to deal with the store
        % structure or not.
        switch nargin(problem.costgrad)
            case 1
                [cost, grad] = problem.costgrad(x);
            case 2
                [cost, grad, store] = problem.costgrad(x, store);
            otherwise
                up = MException('manopt:getCostGrad:badcostgrad', ...
                    'costgrad should accept 1 or 2 inputs.');
                throw(up);
        end

    else
    %% Revert to calling getCost and getGradient separately
    
        [cost, store] = getCost(problem, x, store);
        [grad, store] = getGradient(problem, x, store);
        
    end
    
end
