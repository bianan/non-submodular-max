# Guarantees for Greedy Maximization of Non-submodular Functions


This repository collects source code for the paper:

"Guarantees for Greedy Maximization of Non-submodular Functions with Applications."

 ICML 2017. A.  Bian, J. Buhmann, A. Krause and S. Tschiatschek.


## Usage:

### File Structure:

The subfolders contain source files for the experiments:

- "Bayesian-A-Optimality": Bayesian experimental design with the A-optimality objective

- "LP": LPs with combinatorial constraints

- "Determinantal-Function": Determinantal functions maximization

The subfolder "utilities" contains the utility functions.

One can refer to the README file in each subfolder to
run the experiments and tune the setup parameters.

### Dependencies:

- This implementation uses the SDP solver provided by  [CVX (Version 2.1)](http://cvxr.com/cvx/) and the MATLAB LP solver [linprog](https://ch.mathworks.com/help/optim/ug/linprog.html)

- The code has been tested on Ubuntu 16.04 LTS, 64 bits with MATLAB R2016a. It should work with other OS with little change.

## Copyright:

Copyright (2017) [Yatao (An) Bian | ETH Zurich]  

Please cite the above paper if you are using this code in your work.

The code may be used free of charge for non-commercial and
educational purposes, the only requirement is that this text is
preserved within the derivative work. For any other purpose one
must contact the authors for permission.
