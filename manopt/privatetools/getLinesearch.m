function [t, store] = getLinesearch(problem, x, d, store)
% Returns a hint for line-search algorithms.
%
% function [t, store] = getLinesearch(problem, x, d)
% function [t, store] = getLinesearch(problem, x, d, store)
%
% For a line-search problem at x along the tangent direction d, computes
% and returns t such that retracting t*d at x yields a good point around
% where to look for a line-search solution. That is: t is a hint as to "how
% far to look" along the line.
% 
% The cache structure store is passed along, possibly modified and
% returned in the process.
%
% See also: canGetLinesearch

% This file is part of Manopt: www.manopt.org.
% Original author: Nicolas Boumal, July 17, 2014.
% Contributors: 
% Change log: 
%
%   April 2, 2015 (NB):
%       Only works with the store associated to x, not the whole storedb.

    if nargin < 4
        store = getEmptyStore();
    end


    if isfield(problem, 'linesearch')
    %% Compute the line-search hint function using linesearch.
	
        % Check whether the linesearch function wants to deal with the
        % store structure or not.
        switch nargin(problem.linesearch)
            case 2
                t = problem.linesearch(x, d);
            case 3
                [t, store] = problem.linesearch(x, d, store);
            otherwise
                up = MException('manopt:getLinesearch:badfun', ...
                    'linesearch should accept 2 or 3 inputs.');
                throw(up);
        end

    else
    %% Abandon computing the line-search function.

        up = MException('manopt:getLinesearch:fail', ...
            ['The problem description is not explicit enough to ' ...
             'compute a line-search hint.']);
        throw(up);
        
    end
    
end
