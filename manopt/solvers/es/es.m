function [xbest, fbest, info, options] = es(problem, x, sigma, options)
% (1+1)-Evolution Strategy (ES) with 1/5th rule for derivative-free
% minimization.
%
% function [x, cost, info, options] = es(problem, x0, sigma0, options)
%
% Apply the (1+1)-ES with 1/5th rule mutation strength adaptation to the
% problem defined in the problem structure, starting with the initial
% parental individual x0 and initial mutation strength sigma0.
%
% In addition, options can be provied. None of the options are mandatory.
% See in code for details.

    % Verify that the problem description is sufficient for the solver.
    if ~canGetCost(problem)
        warning('manopt:getCost', ...
            'No cost provided. The algorithm will likely abort.');
    end

    % Dimension of the manifold
    dim = problem.M.dim();

    % Set local defaults here
    localdefaults.storedepth = 0;                   % no need for caching
    localdefaults.maxiter = max(500, 4*dim);

    % Merge global and local defaults, then merge w/ user options, if any.
    localdefaults = mergeOptions(getGlobalDefaults(), localdefaults);
    if ~exist('options', 'var') || isempty(options)
        options = struct();
    end
    options = mergeOptions(localdefaults, options);

    % Start timing for initialization
    timetic = tic();

    % Create a store database and a key for the initial parental individual
    storedb = StoreDB(options.storedepth);
    xkey = storedb.getNewKey();

    % Compute cost for parental individual
    fx = getCost(problem, x, storedb, xkey);
    costevals = 1;

    fbest = fx;
    xbest = x;
    xbestkey = xkey;

    % Iteration counter (at any point, iter is the number of fully executed
    % iterations so far)
    iter = 0;

    % Save stats in a struct array info, and preallocate.
    % savestats will be called twice for the initial iterate (number 0),
    % which is unfortunate, but not problematic.
    stats = savestats();
    info(1) = stats;
    info(min(10000, options.maxiter+1)).iter = [];

    % Start iterating until stopping criterion triggers
    while true

        stats = savestats();
        info(iter+1) = stats;
        iter = iter + 1;

        % Make sure we don't use too much memory for the store database
        storedb.purge();

        % Log / display iteration information here.
        if options.verbosity >= 2
            fprintf('Cost evals: %7d\tBest cost: %+.8e\n', costevals, fbest);
        end

        % Start timing this iteration
        timetic = tic();

        % Standard stopping criterion checks.
        [stop, reason] = stoppingcriterion(problem, x, options, info, iter);
        if stop
            if options.verbosity >= 1
                fprintf([reason '\n']);
            end
            break;
        end

        % Compute offspring
        y = problem.M.retr(x, problem.M.randvec(x), sigma);
        ykey = storedb.getNewKey();
        fy = getCost(problem, y, storedb, ykey);
        costevals = costevals + 1;

        if fy <= fx
          x = y;
          xkey = ykey;
          fx = fy;
          sigma = 1.5 * sigma;
        else
          sigma = 1.5 ^ (-1/4) * sigma;
        end

    end

    xbest = x;
    fbest = fx;

    info = info(1:iter);

    % Routine in charge of collecting the current iteration stats
    function stats = savestats()
        stats.iter = iter;
        stats.cost = fbest;
        stats.costevals = costevals;
        stats.x = x;
        stats.xbest = xbest;
        if iter == 0
            stats.time = toc(timetic);
        else
            stats.time = info(iter).time + toc(timetic);
        end

        % Begin storing user defined stats
        num_old_fields = size(fieldnames(stats), 1);
        trialstats = applyStatsfun(problem, x, storedb, xkey, options, stats);
        new_fields = fieldnames(trialstats);
        num_new_fields = size(fieldnames(trialstats), 1);
        num_additional_fields =  num_new_fields - num_old_fields; % User has defined new fields
        for jj = 1 : num_additional_fields % New fields added
            tempfield = new_fields(num_old_fields + jj);
            stats.(char(tempfield)) = cell(options.populationsize, 1);
        end
        tempstats = applyStatsfun(problem, x, storedb, xkey, options, stats);
        for jj = 1 : num_additional_fields
          tempfield = new_fields(num_old_fields + jj);
          tempfield_value = tempstats.(char(tempfield));
          stats.(char(tempfield)) = tempfield_value;
        end
        % End storing

    end


end
