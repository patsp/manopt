function [egrad, store] = getEuclideanGradient(problem, x, store)
% Computes the Euclidean gradient of the cost function at x.
%
% function [egrad, store] = getEuclideanGradient(problem, x)
% function [egrad, store] = getEuclideanGradient(problem, x, store)
%
% Returns the Euclidean gradient at x of the cost function described in the
% problem structure. The cache structure store is passed along, possibly
% modified and returned in the process.
%
% Because computing the Hessian based on the Euclidean Hessian will require
% the Euclidean gradient every time, to avoid overly redundant
% computations, if the egrad function does not use the store caching
% capabilities, we implement an automatic caching functionality. This
% means extra memory will be used for caching, "behind the scenes".
% How much memory is used can be controled via options.storedepth.
%
% If you absolutely do not want caching to be used, you can define grad
% instead of egrad, without store support, and call problem.M.egrad2rgrad
% manually.
%
% See also: getGradient canGetGradient canGetEuclideanGradient

% This file is part of Manopt: www.manopt.org.
% Original author: Nicolas Boumal, July 9, 2013.
% Contributors: 
% Change log: 
%
%   April 2, 2015 (NB):
%       Only works with the store associated to x, not the whole storedb.

    if nargin < 3
        store = getEmptyStore();
    end

    
    if isfield(problem, 'egrad')
    %% Compute the Euclidean gradient using egrad.
	
        % Check whether the egrad function wants to deal with the store
        % structure or not.
        switch nargin(problem.egrad)
            case 1
                % If it does not want to deal with the store structure,
                % then we do some caching of our own.
                if ~isfield(store, 'egrad__')
                    store.egrad__ = problem.egrad(x);
                end
                egrad = store.egrad__;
            case 2
                % Otherwise we don't do any automatic caching:
                % the user is in control.
                [egrad, store] = problem.egrad(x, store);
            otherwise
                up = MException('manopt:getEuclideanGradient:badegrad', ...
                    'egrad should accept 1 or 2 inputs.');
                throw(up);
        end

    else
    %% Abandon computing the Euclidean gradient
    
        up = MException('manopt:getEuclideanGradient:fail', ...
            ['The problem description is not explicit enough to ' ...
             'compute the Euclidean gradient of the cost.']);
        throw(up);
        
    end
    
end
