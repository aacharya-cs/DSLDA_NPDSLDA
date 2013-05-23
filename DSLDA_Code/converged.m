function b = converged(u,udash,threshhold)
% converged(u,udash,threshhold)
% Returns 1 if u and udash are not different by the ratio threshhold
% (default 0.001).
% threshold

if (nargin < 3)
  threshhold = 1.0e-3;
end
% main
if (diff_vec(u, udash) < threshhold)
  b = true;
else
  b = false;
end
