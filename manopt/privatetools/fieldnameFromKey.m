function fname = fieldnameFromKey(key)
% Converts a key into a valid fieldname for use with storedb caching
%
% function fname = fieldnameFromKey(key)
%
% The input 'key' may be a string (letters, digits and underscores, nothing
% else, in particular, no spaces) or an integer (not a double).
%
% See also: setStore purgeStoredb

% This file is part of Manopt: www.manopt.org.
% Original author: Nicolas Boumal, April 2, 2015.
% Contributors: 
% Change log:

    if ischar(key)
        fname = ['z' key(:)'];
    elseif isinteger(key) && numel(key) == 1
        fname = sprintf('z%d', key);
        % it's faster than this: fname = ['z' int2str(key)];
    else
        error('key must be a string or an integer (not a double).');
    end

end
