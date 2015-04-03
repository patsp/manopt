function store = getEmptyStore()
% Returns a store structure with no information inside.
%
% function store = getEmptyStore()
% 
% This function returns the same structure getStore() would return
% if given an unknown key and storedb had no permanent data attached.
%
% See also: getStore setStore

% This file is part of Manopt: www.manopt.org.
% Original author: Nicolas Boumal, April 2, 2015.
% Contributors: 
% Change log: 

    store = struct();
	store.permanent = struct();
    
end
