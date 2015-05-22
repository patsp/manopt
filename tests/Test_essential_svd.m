function Test_essential_svd
% Sample solution of an optimization problem on the essential manifold
% Solves the problem \sum_{i=1}^N ||E_i-A_i||^2, where E_i are essential
% matrices.

% This file is part of Manopt: www.manopt.org.
% Original author: Roberto Tron, Aug. 8, 2014
% Contributors: Bamdev Mishra, May 15, 2015.


    % Make data for the test
    N = 2;    %number of matrices to process in parallel
    A = multiprod(multiprod(randrot(3, N), essential_hat3([0; 0; 1])), randrot(3, N));
    
    % The essential manifold
    M = essentialfactory(N);
    problem.M = M;
    
    % Function handles of the essential matrix E and Euclidean gradient and Hessian
    costE = @(E) 0.5*sum(multitrace(multiprod(multitransp(E - A),(E - A))));
    egradE = @(E) E - A;
    ehessE = @(E, U) U;

    
    % Manopt descriptions
    problem.cost = @cost;
    function val = cost(X)
        val = essential_costE2cost(X, costE); % Cost
    end
    
    problem.egrad = @egrad;
    function g = egrad(X)
        g = essential_egradE2egrad(X, egradE); % Converts gradient in E to X.
    end
    
    problem.ehess = @ehess;
    function gdot = ehess(X, S)
        gdot = essential_ehessE2ehess(X, egradE, ehessE, S); % Converts Hessian in E to X.
    end
    
    
    % Numerically check the differentials.
    checkgradient(problem); pause;
    checkhessian(problem); pause;
    
    %Solve the problem
    Xsol = trustregions(problem);
    
    % Distance between original matrices and decompositions
    val = essential_costE2cost(Xsol, costE);
    fprintf('Distance between original matrices and decompositions is %e \n', val);

end







