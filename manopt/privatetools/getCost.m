function [cost, store] = getCost(problem, x, store)
% Computes the cost function at x.
%
% function [cost, store] = getCost(problem, x)
% function [cost, store] = getCost(problem, x, store)
%
% Returns the value at x of the cost function described in the problem
% structure. The cache database storedb is passed along, possibly modified
% and returned in the process. key is the storedb key associated to x.
%
% See also: canGetCost

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


    if isfield(problem, 'cost')
    %% Compute the cost function using cost.
	
        % Check whether the cost function wants to deal with the store
        % structure or not.
        switch nargin(problem.cost)
            case 1
                cost = problem.cost(x);
            case 2
                [cost, store] = problem.cost(x, store);
            otherwise
                up = MException('manopt:getCost:badcost', ...
                    'cost should accept 1 or 2 inputs.');
                throw(up);
        end
        
    elseif isfield(problem, 'costgrad')
    %% Compute the cost function using costgrad.
	
        % Check whether the costgrad function wants to deal with the store
        % structure or not.
        switch nargin(problem.costgrad)
            case 1
                cost = problem.costgrad(x);
            case 2
                [cost, grad, store] = problem.costgrad(x, store); %#ok
            otherwise
                up = MException('manopt:getCost:badcostgrad', ...
                    'costgrad should accept 1 or 2 inputs.');
                throw(up);
        end

    else
    %% Abandon computing the cost function.

        up = MException('manopt:getCost:fail', ...
            ['The problem description is not explicit enough to ' ...
             'compute the cost.']);
        throw(up);
        
    end
    
end
