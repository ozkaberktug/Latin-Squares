# Latin-Squares

This repository contains several approches to create n-degree latin squares. Some folders contain makefile so just
run `make`. Main test criteria was the generation time needed for n = 6.


## Folder Descriptions

* `different-algorithm/`  
I have tried to use 2 by 2 matrices to fill up a square. Recursive calls for backtracking is reduced but overall timing
did not.

* `single-thread-solution/`  
Simple straight-forward bactrack solution. On Intel i5-2450M @ 2.50GHz CPU the process took approximetly 47 mins.

* `multi-thread-solution/`  
On Linux using PThreads required time to solve latin squares degree of 6 on the same CPU was approximetly 23 mins.
Algorithm does not care about optimization of number of threads.. Basically, N threads created for N-degree square.

* `ultra-spec-solution/`  
I used CUDA 8.0 to compile the code. Code written for compute capability of 2.1 (Fermi). In Fermi, recursive functions do
not supported. Therefore, I converted the recursive backtrack function into "iterative" one by using a stack structure and
`goto` statements. (Yeah, I know gotos and labels not cool etc.) That's why I gave the name ultra spec to this solution
But interestingly the time required to generate square was too long that I could not wait it after 1 hr.
I think, GPUs are not well suited for these kind of complex operations.

* `gpu-solution/`  
Think as a step to achive ultra-spec-solution. I rewrite the code after but kept the directory.

