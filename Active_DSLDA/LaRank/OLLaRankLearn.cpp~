// -*- C++ -*-
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

#include <cstdlib>
#include <sys/time.h>
#include <cstdarg>
#include <cstdio>
#include <cstring>
#include <cfloat>
#include <cassert>
#include "vectors.h"
#include "LaRank.h"

Machine* training (Machine* svm, Exampler train, const SVector& xdata, int lab)
{
  int n_it=0;
  double initime=getTime(), gap = DBL_MAX;
  double tr_err = 0;
  
  std::cout << "\n--> Training on " << train.nb_ex << "ex" << std::endl;
  if (svm->add(xdata, lab) != lab)	
      tr_err++;     
  svm->printStuff(initime, false);      
  gap = svm->computeGap();
  std::cout << "Duality gap: "<< gap<< std::endl;
  std::cout << "Train error (online): "<< (tr_err / train.nb_ex) *100 << "%" << std::endl;
  svm->printStuff(initime, true);
  std::cout << "---- End of training ----" << std::endl;
  return svm;
}

Machine* OLLaRankLearn (Machine* svm)
{
  // take an existing machine and modify it with one example
  Exampler train;
  int i, mode = 0;
  double C = 1, verb = 10, tau = 0.0001;
    
  // CREATE		
  int step = (int) ((double) train.nb_ex / (100 / verb));  
  training(svm, train, xdata, label);
  return svm;		
}
