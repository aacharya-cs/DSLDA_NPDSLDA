// -*- C++ -*-
// Main functions for learning a Multiclass SVM Classifier with LaRank
// Copyright (C) 2008- Antoine Bordes

// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111, USA

#include <iostream>
#include <vector>
#include <algorithm>

#include <cstdlib>
#include <sys/time.h>
#include <cstdarg>
#include <cstdio>
#include <cstring>
#include <cfloat>
#include <cassert>

#include "vectors.h"
#include "LaRank.h"

// GLOBAL VARIABLES

// kernel function
int kernel_type;
double degree;
double kgamma;
double coef0;

// Training data
Exampler ex;
int nb_train;
long nb_kernel;


// Types of kernel functions LaRank can deal with
double
kernel (int xi_id, int xj_id, void *kparam)
{
  SVector xi = ex.data[xi_id].inpt;
  SVector xj = ex.data[xj_id].inpt;
  double vdot = dot (xi, xj);
  nb_kernel++;
  switch (kernel_type)
    {
    case 0:
      return vdot;
    case 1:
      return pow (kgamma * vdot + coef0, degree);
    case 2:
      return exp (-kgamma * (ex.data[xi_id].norm + ex.data[xj_id].norm - 2 * vdot));
    }
  return 0;
}


void
exit_with_help ()
{
  fprintf (stdout,
	   "\nLA_RANK_LEARN: learns models for multiclass classification with the 'LaRank algorithm'.\n"
	   "\nUsage: la_rank_learn [options] training_set_file model_file\n"
	   "options:\n"
	   "-c cost : set the parameter C (default 1)\n"
	   "-e tau : threshold determining tau-violating pairs of coordinates (default 1e-4) \n"
	   "-t kernel function (default 0):\n"
	   "\t0 linear : K(X,X')=X*X'\n"
	   "\t1 polynomial : K(X,X')=(g*X*X'+c0)^d\n"
	   "\t2 rbf : K(X,X')=exp(-g*||X-X'||^2)\n"
	   "-g gamma : coefficient for polynomial and rbf kernels (default 1)\n"
	   "-d degree of polynomial kernel (default 2)\n"
	   "-b c0 coefficient for polynomial kernel (default 0)\n"
	   "-k cache size : in MB (default 64)\n"
	   "-m mode : set the learning mode (default 0)\n"
	   "\t 0: online learning\n"
	   "\t 1: batch learning (stopping criteria: duality gap < C)\n"
	   "-v verbosity degree : display informations every v %% of the training set size (default 10)\n");
  exit (1);
}

// TRAINING here
void
training (Machine * svm, Exampler train, int mode, int step)
{
  ex = train;
  int n_it = 1;
  double initime = getTime (), gap = DBL_MAX;

  std::cout << "\n--> Training on " << train.nb_ex << "ex" << std::endl;
  while (gap > svm->C)		// stopping criteria
    {
      double tr_err = 0;
      int ind = step;
      for (int i = 0; i < nb_train; i++)
	{
	  if (svm->add (i, ex.data[i].cls) != ex.data[i].cls)	// call the add function
	    tr_err++;
	  if (i / ind)
	    {
	      std::cout << "Done: " << (int) (((double) i) / ex.nb_ex * 100) << "%, Train error (online): " << (tr_err / ((double) i + 1)) * 100 << "%" << std::endl;
	      svm->printStuff (initime, false);
	      ind += step;
	    }
	}

      std::cout << "End of iteration " << n_it++ << std::endl;
      std::cout << "Train error (online): " << (tr_err / nb_train) * 100 << "%" << std::endl;
      gap = svm->computeGap ();
      std::cout << "Duality gap: " << gap << std::endl;
      svm->printStuff (initime, true);
      if (mode == 0)		// skip stopping criteria if online mode
	gap = 0;
    }
  std::cout << "---- End of training ---- (Computed kernels " << nb_kernel << ")"<< std::endl;
}


void
save_model (Machine * svm, const char *file)
{
  std::cout << "\n--> Saving Model in \"" << file << " \" " << std::endl;
  std::ofstream ostr (file);
  svm->save_outputs (ostr);
}


int
main (int argc, char *argv[])
{
  Exampler train;
  Exampler model;
  int i, mode = 0;
  double C = 1, verb = 10, tau = 0.0001;
  long cache = 64;
  kernel_type = 0;
  kgamma = 1.;
  coef0 = 0;
  degree = 2.;

  // parse options
  for (i = 1; i < argc; i++)
    {
      if (argv[i][0] != '-')
	break;
      ++i;
      switch (argv[i - 1][1])
	{
	case 'c':
	  C = atof (argv[i]);
	  break;
	case 't':
	  kernel_type = atoi (argv[i]);
	  break;
	case 'b':
	  coef0 = atof (argv[i]);
	  break;
	case 'd':
	  degree = atof (argv[i]);
	  break;
	case 'g':
	  kgamma = atof (argv[i]);
	  break;
	case 'm':
	  mode = atoi (argv[i]);
	  break;
	case 'e':
	  tau = atof (argv[i]);
	  break;
	case 'v':
	  verb = atof (argv[i]);
	  break;
	case 'k':
	  cache = atol (argv[i]);
	  break;
	default:
	  fprintf (stderr, "unknown option\n");
	}
    }
  // determine filenames
  if (i >= (argc - 1))
    exit_with_help ();
  std::cout << "Loading Train Data " << std::endl;
  train.libsvm_load_data (argv[i], false);

  // build and initialize the LaRank object
  std::cout << "\n--> Building with C = " << C << std::endl;
  Machine *svm = create_larank ();
  int step = (int) ((double) train.nb_ex / (100 / verb));
  svm->tau = tau;
  svm->C = C;
  svm->kfunc = kernel;
  svm->cache = (int) (cache / train.nb_labels);

  nb_train = train.nb_ex;
  nb_kernel = 0;

  switch (kernel_type)
    {
    case 0:
      std::cout << "Linear Kernel" << std::endl;
      break;
    case 1:
      std::
	cout << "Polynomial Kernel with g=" << kgamma << " ,d=" << degree <<" ,c0=" << coef0 << std::endl;
      break;
    case 2:
      std::cout << "RBF Kernel with g=" << kgamma << std::endl;
      break;
    default:
      std::cout << "Linear Kernel" << std::endl;
    }
  if (!mode)
    std::cout << "Online Learning (One Epoch) " << std::endl;
  else
    std::cout << "Batch Learning (until duality gap < C)" << std::endl;

  // train LaRank
  training (svm, train, mode, step);

  // save the model
  save_model (svm, argv[i + 1]);
  svm->destroy ();

}
