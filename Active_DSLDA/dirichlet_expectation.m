function [retval] = dirichlet_expectation(alpha)

[N M] = size(alpha);
if (min(N, M) == 1)
    retval = psi(alpha) - psi(sum(alpha));
else
    retval = psi(alpha) - psi(repmat(sum(alpha,1), N, 1));
end

end