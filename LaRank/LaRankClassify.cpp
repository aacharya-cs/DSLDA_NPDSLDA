// -*- C++ -*-
// Main functions for testing a Multiclass SVM Classifier learned with LaRank
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

// GLOBAL VARIALBLES

// Kernel
int kernel_type;
double degree;
double kgamma;
double coef0;

// Testing data
Exampler ex;
int nb_train;
long nb_kernel;

// Kernel function
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
	   "\nLA_RANK_CLASSIFY: uses models learned with the 'LaRank algorithm' for multiclass classification to make prediction.\n"
	   "\nUsage: la_rank_classify [options] training_set_file testing_set_file model_file\n"
	   "options:\n"
	   "-t kernel function (default 0):\n"
	   "\t0 linear : K(X,X')=X*X'\n"
	   "\t1 polynomial : K(X,X')=(g*X*X'+c0)^d\n"
	   "\t2 rbf : K(X,X')=exp(-g*||X-X'||^2)\n"
	   "-g gamma : coefficent for polynomial and rbf kernels (default 1)\n"
	   "-d degree of polynomial kernel (default 2)\n"
	   "-b c0 coefficient for polynomial kernel (default 0)\n");
  exit (1);
}

// TESTING here
void
testing (Machine * svm, Exampler test)
{
  ex = test;
  double err = 0;
  std::cout << "\n--> Testing on " << test.nb_ex -
    nb_train << "ex" << std::endl;
  for (int i = nb_train; i < test.nb_ex; i++)
    {
      int ypred = svm->predict (i);	// call the predict function
      if (ypred != test.data[i].cls)
	err++;
    }
  std::cout << "Test Error:" << 100 * (err/(test.nb_ex - nb_train)) << "%" << std::endl;
}


Machine *
load_model (char *file, int cs)
{
  std::cout << "\nLoading Model " << std::endl;
  Exampler model;
  model.libsvm_load_data (file, true);
  Machine *svm = create_larank ();

  svm->kfunc = kernel;
  svm->cache = cs;
  svm->add_outputs (model);
  switch (kernel_type)
    {
    case 0:
      std::cout << "Linear Kernel" << std::endl;
      break;
    case 1:
      std::cout << "Polynomial Kernel with g=" << kgamma << " ,d=" << degree <<" ,c0=" << coef0 << std::endl;
      break;
    case 2:
      std::cout << "RBF Kernel with g=" << kgamma << std::endl;
      break;
    default:
      std::cout << "Linear Kernel" << std::endl;
    }
  return svm;
}


int
main (int argc, char *argv[])
{
  Exampler test;
  Exampler tmp;
  int i;
  kernel_type = 0;
  kgamma = 1.;
  coef0 = 0;
  degree = 1.;

  // parse options
  for (i = 1; i < argc; i++)
    {
      if (argv[i][0] != '-')
	break;
      ++i;
      switch (argv[i - 1][1])
	{
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
	default:
	  fprintf (stderr, "unknown option\n");
	}
    }
  // determine filenames
  if (i >= (argc - 2))
    exit_with_help ();
  std::cout << "Loading Train Data " << std::endl;
  test.libsvm_load_data (argv[i], false);
  std::cout << "\nLoading Test Data" << std::endl;
  tmp.libsvm_load_data (argv[i + 1], false);

  nb_train = test.nb_ex;
  for (int ex = 0; ex < tmp.nb_ex; ex++)	// Aggregate train and test data in a big sparse kernel matrix
    test.data.push_back (tmp.data[ex]);
  test.nb_ex += tmp.nb_ex;
  test.max_index = jmax (test.max_index, tmp.max_index);
  test.nb_labels = jmax (test.nb_labels, tmp.nb_labels);

  // load the model
  Machine *svm = load_model (argv[i + 2], test.nb_labels);

  // test the model
  testing (svm, test);

  svm->destroy ();

}
