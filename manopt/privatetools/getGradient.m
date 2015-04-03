function [grad, store] = getGradient(problem, x, store)
% Computes the gradient of the cost function at x.
%
% function [grad, store] = getGradient(problem, x)
% function [grad, store] = getGradient(problem, x, store)
%
% Returns the gradient at x of the cost function described in the problem
% structure. The cache structure store is passed along, possibly modified
% and returned in the process.
%
% See also: getDirectionalDerivative canGetGradient

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

    
    if isfield(problem, 'grad')
    %% Compute the gradient using grad.
	
        % Check whether the gradient function wants to deal with the store
        % structure or not.
        switch nargin(problem.cost)
            case 1
                grad = problem.grad(x);
            case 2
                [grad, store] = problem.grad(x, store);
            otherwise
                up = MException('manopt:getGradient:badgrad', ...
                    'grad should accept 1 or 2 inputs.');
                throw(up);
        end
    
    elseif isfield(problem, 'costgrad')
    %% Compute the gradient using costgrad.
		
        % Check whether the costgrad function wants to deal with the store
        % structure or not.
        switch nargin(problem.costgrad)
            case 1
                [unused, grad] = problem.costgrad(x); %#ok
            case 2
                [unused, grad, store] = problem.costgrad(x, store); %#ok
            otherwise
                up = MException('manopt:getGradient:badcostgrad', ...
                    'costgrad should accept 1 or 2 inputs.');
                throw(up);
        end
    
    elseif canGetEuclideanGradient(problem)
    %% Compute the gradient using the Euclidean gradient.
        
        [egrad, store] = getEuclideanGradient(problem, x, store);
        grad = problem.M.egrad2rgrad(x, egrad);

    else
    %% Abandon computing the gradient.
    
        up = MException('manopt:getGradient:fail', ...
            ['The problem description is not explicit enough to ' ...
             'compute the gradient of the cost.']);
        throw(up);
        
    end
    
end
