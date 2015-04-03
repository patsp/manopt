function stats = applyStatsfun(problem, x, store, options, stats)
% Apply the statsfun function to a stats structure (for solvers).
%
% function stats = applyStatsfun(problem, x, store, options, stats)
%
% Applies the options.statsfun user supplied function to the stats
% structure, if it was provided, with the appropriate inputs, and returns
% the (possibly) modified stats structure.
%
% See also: 

% This file is part of Manopt: www.manopt.org.
% Original author: Nicolas Boumal, April 3, 2013.
% Contributors: 
% Change log: 
%
%   April 2, 2015 (NB):
%       Only asks for the store associated to x, not the whole storedb.

	if isfield(options, 'statsfun')
		
        switch nargin(options.statsfun)
            case 3
                stats = options.statsfun(problem, x, stats);
            case 4
                stats = options.statsfun(problem, x, stats, store);
            otherwise
                warning('manopt:statsfun', ...
                        'statsfun unused: wrong number of inputs');
        end
	end

end
