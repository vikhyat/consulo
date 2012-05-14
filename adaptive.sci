function y = f(x)
  y = sin(x * 10 / (2 * %pi));
//  y = x;
//  y = 2;
endfunction

function A = addto(A, x)
  A = [A x];
endfunction

function A = naive_polling(freq, samples)
  A = []
  for i = 0:(samples-1)
    A = addto(A, [i*freq; f(i*freq)]);
  end;
endfunction

function A = adaptive_polling_single(wait, samples, alpha, delta)
  A = [];
  t = 0;
  S = 0; // forecast
  for i = 1:samples
    if abs(S - f(t)) > delta
      wait = wait * 0.5;
    else
      wait = wait * 1.1;
    end;
    A = addto(A, [t; f(t)]);
    S = alpha * f(t) + (1 - alpha) * S;
    t = t + wait;
  end;
endfunction

function A = adaptive_polling_double(wait, samples, alpha, beta, delta)
  A = [];
  t = 0;
  Sc = 0; // S_t+1
  Sp = 0; // S_t
  bc = 0; // b_t+1
  bp = 0; // b_t
  for i = 1:samples
    if abs(Sc - f(t)) > delta
      wait = wait * 0.5;
    else
      wait = wait * 1.1;
    end;
    A = addto(A, [t; f(t)]);
    // forecasting
    temp = Sc;
    Sc = alpha * f(t) + (1 - alpha) * (Sp + bp)
    Sp = temp;
    temp = bc;
    bc = beta * (Sc - Sp) + (1 - beta) * bp;
    bp = temp;
    // next sample
    t = t + wait;
  end;
endfunction

function plot_output(A)
  // plot the actual function
  range = min(A(1,:)):0.1:max(A(1,:));
  plot(range, f(range), 'r');
  // plot what we got
  plot(A(1,:), A(2,:), 'bd-');
endfunction

function y=avg_error(predictions)
  range = linspace(0, max(predictions(1, :)), 100)
  error = 0
  for i = range
    error = error + abs(f(i) - interpln(predictions, [i]))
  end;
  y = error / length(range)
endfunction
