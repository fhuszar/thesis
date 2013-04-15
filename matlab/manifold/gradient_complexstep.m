function [y,df] = gradient_complexstep(x,f,epsilon)

D = numel(x);
if iscell(f)
    y = feval(f{1}, x, fAndArgs{2:end});
else
    y = feval(f, x);
end;

df = zeros(numel(y),numel(x));
tx = x;

for d = 1:D

  % evaluate x a bit above
  tx(d) = x(d) + 1i*epsilon; % perturb a single dimension
  if iscell(f)
    y2 = feval(f{1}, tx, fAndArgs{2:end});
  else
    y2 = feval(f, tx);
  end;

  tx(d) = x(d); % reset the perturbed element to the original value

  df(:, d) = imag(y2(:)) / epsilon; % estimate the gradient

end