function store = getStore(storedb, key)
% Extracts a store struct. pertaining to a point from the storedb database.
%
% function store = getStore(storedb)
% function store = getStore(storedb, key)
%
% Queries the storedb database of structures (itself a structure) and
% returns the store structure corresponding to a point x, using its key.
% If there is no record with that key or the key is ommitted, builds an
% empty structure.
%
% That structure is then complemented with a field called 'permanent'. That
% field can also be modified, and will be the same regardless of x. In
% other words: it makes it possible to store and pass information around
% between different points.
%
% See also: setStore purgeStoredb

% This file is part of Manopt: www.manopt.org.
% Original author: Nicolas Boumal, Dec. 30, 2012.
% Contributors: 
% Change log:
%
%   April 2, 2015, NB:
%       storedb may now contain a special field, called 'permanent', which
%       is then added to the returned store. This special field is not
%       associated to a specific store; it is passed around from call to
%       call, to create a 'permanent memory' that spans, for example, all
%       iterations of a solver's execution.
%
%   April 2, 2015, NB:
%       getStore now asks for a key rather than (problem, x). Thus, no more
%       hash calls inside getStore.
    
    % By default, create an empty structure.
    store = struct();
    
    % If there is a key, and data is stored for this key, extract it.
    if nargin > 1
        % Get to know in what field that key is stored.
        fname = fieldnameFromKey(key);
        if isfield(storedb, fname)
            store = storedb.(fname);
        end
    end
    
    % If there is a permanent memory, add it.
    % Otherwise, add an empty structure.
    if isfield(storedb, 'permanent')
        store.permanent = storedb.permanent;
    else
        store.permanent = struct();
    end

end
