%factorial
factorial(N, result):- 
  N>=1, N is N-1,
  factorial(n, result), 
  result is N * result.