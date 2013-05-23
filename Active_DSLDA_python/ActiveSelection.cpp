/*********************************************************************
 * update_phi_cpp.cpp
 * @ Ayan Acharya, Date: Mar 31, 2012
 * input: 1: model, 2: data, 3: psi(1,gamma), 4: option, 5: phase, 6: annotation,
 ********************************************************************/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <matrix.h>
#include <mex.h>

#define Malloc(type,n) (type *)malloc((n)*sizeof(type))
#define MAXCOUNT 10  // maximum number of online E-step iterations 
#define MAXLABELS 10 // maximum number of labels queried per active iteration

double log_sum(double log_a, double log_b)
{
    double v;
    if (log_a == 0) return(log_b);
    if (log_b == 0) return(log_a);
    if (log_a < log_b)
        v = log_b+log(1 + exp(log_a-log_b));
    else
        v = log_a+log(1 + exp(log_b-log_a));
    return(v);
}

void update_phin(double *temp_phin, const mxArray *phi_n, const double *windexn, const double *wcountn, const mxArray *model, const mxArray *data, const double *psigammaptr, const int n, const int phase, const double *annotations, int option)
{
    int ndistWords, nK, k1, k2, V, N, tempind, i, j, y, C2, Y; // number of words, maximum number of topics, maximum number of observed topics
    double logsum1, logsum2, minval, val, epsilon;
    mxArray *tmp;
    double *tmpptr, *tmp1, *log_beta, *mu, *eta, *classlabels;
    double *nwordspdoc = mxGetPr(mxGetField(data,0,"nwordspdoc"));
    
    minval = mxGetScalar(mxGetField(model,0,"MINVALUE"));
    ndistWords = mxGetM(phi_n);
    nK     = mxGetN(phi_n);
    tmp    = mxCreateDoubleMatrix(ndistWords,nK,mxREAL);
    tmpptr = mxGetPr(tmp);
    log_beta = mxGetPr(mxGetField(model,0,"log_beta"));
    V      = mxGetScalar(mxGetField(model,0,"V"));
    
    //mexPrintf("till here ok1\n");
    if(option>=3)
    {
        classlabels = mxGetPr(mxGetField(data,0,"classlabels"));
        mu      = mxGetPr(mxGetField(model,0,"mu"));
        eta     = mxGetPr(mxGetField(model,0,"eta"));
        C2 = (int)mxGetScalar(mxGetField(model,0,"C2"));
        Y  = (int)mxGetScalar(mxGetField(model,0,"Y"));
        if(option>=4)
        {
            k1 = mxGetScalar(mxGetField(model,0,"k1"));
            k2 = mxGetScalar(mxGetField(model,0,"k2"));
            epsilon = mxGetScalar(mxGetField(model,0,"epsilon"));
            //mexPrintf("\nY: %d\n",Y);
        }
    }
    
    int lowlimit, uplimit;
    if(option==5) // DSLDA-NSLT
    {
        lowlimit = k1 + ((int)classlabels[n]-1)*(k2/Y);
        uplimit  = k1 + ((int)classlabels[n])*(k2/Y)-1;
        //mexPrintf("%d %d %d %d %d %d\n", n, k1, k2, lowlimit, uplimit, (int)classlabels[n]);
    }
    //mexPrintf("\t %d acajcjac %d",n, ndistWords);
    for (i=0; i<ndistWords; i++)
    {
        logsum1 = 0;
        logsum2 = 0;
        tmp1 = Malloc(double,nK);
        //mexPrintf("%d %d %d %d till here ok2\n", n, i, windexn[i], ndistWords);
        
        for (j=0; j<nK; j++)
        {
            tempind = j + ((int)(windexn[i])-1)*nK;
            //mexPrintf("\n%d %d %d %d %f\n",n, i,j, nK, log_beta[tempind]);
            val = 0;
            if(unlclass[n]==1 && (int)classlabels[n]>=1)   // use the dual variable in training phase only when label is present; no dual variable in test phase;
            {
                for (y=0; y<Y; y++)
                    val = val + mu[y*N+n]*(eta[j*Y+ (int)classlabels[n]-1] - eta[j*Y+y]);
                val =  val/nwordspdoc[n];
            }
            
            //mexPrintf("\n%d %d %d %d %f\n",n, i,j, nK, log_beta[tempind]);
            if(option>=3)
                *(tmp1+j) = psigammaptr[j*N+n] + log_beta[tempind] + val;  // access (j,i) th element from gamma
            
            if(option==1 || option==2)
                *(tmp1+j) = psigammaptr[j*N+n] + log_beta[tempind];  // access (j,i) th element from gamma
            
            if(option!=1 && option!=3 && ((option>=4 && j<k1) || (option==2 && j<nK)))
            {
                // supervised topics for options other than 1(LDA) and 3(MedLDA); for option 2(LLDA), all the topics are supervised, so we need an extra clause
                    if(option==2 && *(unlattr+j*N+n)==0); // LLDA
                    else if (option==4 && j<k1 && *(unlattr+j*N+n)==0);  // DSLDA
                    else if (option==5 && ((j<k1 && *(unlattr+j*N+n)==0) || (j>=k1 && !(j>=lowlimit && j<=uplimit)))); // DSLDA-NSLT1
                    else if (option==7 && (j<k1 && *(unlattr+j*N+n)==0)); // DSLDA-OSST
                    else
                        logsum1    = log_sum(*(tmp1+j),logsum1);
            }
            else  // unsupervised topics (training and test phases are identical except for DSLDA-NSLT)
            {
                if(phase==1 && (int)classlabels[n]>=1 && option==5 && !(j>=lowlimit && j<=uplimit)); // skip in DSLDA-NSLT's training phase;
            }
        }
        
        // conversion from log space to real number
        for (j=0; j<nK; j++)
        {
            if(option!=1 && option!=3 && ((option>=4 && j<k1) || (option==2 && j<nK)))
            {
                // supervised topics for options other than 1(LDA) and 3(MedLDA); for option 2(LLDA), all the topics are supervised, so we need an extra clause
                    //if condition says when to ignore phi's for supervised topics in training phase
                    if(option==2 && *(unlattr+j*N+n)==0)
                        temp_phin[j*ndistWords+i] = 0; // LLDA
                    else if (option==4 && j<k1 && *(unlattr+j*N+n)==0)
                        temp_phin[j*ndistWords+i] = 0; // DSLDA
                    else if (option==5 && j<k1 && *(unlattr+j*N+n)==0)
                        temp_phin[j*ndistWords+i] = 0; // DSLDA-NSLT
                    else if (option==7 && (j<k1 && *(unlattr+j*N+n)==0))
                        temp_phin[j*ndistWords+i] = 0; // DSLDA-OSST
                    else if(logsum1 - *(tmp1+j)>100)
                        temp_phin[j*ndistWords+i] = minval;                                //(j,i) th element
                    else if(logsum1 - *(tmp1+j)<100)
                        temp_phin[j*ndistWords+i] = epsilon*exp(*(tmp1+j)-logsum1)+minval; //(j,i) th element
                    else; // do nothing
            }
            else  // unsupervised topics
            {
                if((int)classlabels[n]>=1 && option==5 && !(j>=lowlimit && j<=uplimit)) // DSLDA-NSLT skip in training phase only if the class label is present
                    tmpptr[j*ndistWords+i] = 0;
                else // no distinction between training and test phase except for DSLDA-NSLT
                {
                    if(logsum2 - *(tmp1+j)>100)
                        temp_phin[j*ndistWords+i] = minval;                        //(j,i) th element
                    if(logsum2 - *(tmp1+j)<100)
                        if(option>=4)
                            temp_phin[j*ndistWords+i] = (1-epsilon)*exp(*(tmp1+j)-logsum2)+minval; //(j,i) th element
                        else
                            temp_phin[j*ndistWords+i] = exp(*(tmp1+j)-logsum2)+minval; //(j,i) th element
                }
            }
        }
        free(tmp1);
    }     
    return;
}


void update_gamman(const double *temp_gamman, const mxArray *phi_n, const double *windexn, const double *wcountn, const mxArray *model, const mxArray *data, const int n, const int phase, const double *annotations, int option)
{
 int dimx, nK, k;
 double value, *alpha1, *alpha2;

 dimx   = (int)mxGetM(phi_n);
 nK     = (int)mxGetN(phi_n);
 alpha1 = mxGetPr(mxGetField(model,0,"alpha1"));
 alpha2 = mxGetPr(mxGetField(model,0,"alpha2"));

 for (k=0; k<nk: k++)
 {           
   value = 0;
   for(int j=0; j<dimx; j++)
   {
     value+= wcountn[j]*phin[k*dimx+j]; //w_{nm'}*phi_{nm'k}
   }
   if(k<K1 && unlattr[tempn, k]==1 && annotations[tempn, k]==1)
    temp_gamman[k] = alpha1[k] + value;    // supervised topics
   if(k>=K1)
    temp_gamman[k] = alpha2[k-K1] + value; // unsupervised topics
 }
 return;
}

double cal_EER(model, data, temp_phin, temp_gamman)
{
 double val = 0;
 // to do
 return val;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    const mxArray *model, *data;
    mxArray *phi, *phin, *windex, *wcount, *nwordspdoc, *mu, *classlabels, *eta;
    double  *tmp3, *tmp31, *tmp32, *tmp5, *windexn, *wcountn, *annotations, *psigamma;
    double *sstopicwordptr, *sstopicptr, *unlobj, *unlattr, rhot;
    int Nsz, nK, C2, Y, V, K1, k1, numlabels, MAXNUMLABELS; 
    int option = (int)mxGetScalar(prhs[3]); 
    int *EEP_vals; 
  
    //get the model and the complete data
    model    = prhs[0];
    data     = prhs[1];    
    // here comes unlabeled data
    unlobj   = prhs[2]; 
    // a vector of unlabeled image indices; an image is considered unlabeled until all of its annotations and class labels are known
    unlclass = prhs[3]; 
    // indicator for whether class labels are known or not; a binary matrix;  with 0 representing unlabeled class label in an image
    unlattr  = prhs[4]; 
    // a binary matrix;  with 0 representing unlabeled attributes    
    
    Nunlobj  = max(mxGetM(unlobj), mxGetN(unlobj));
    Nunlattr = max(mxGetM(unlattr));
    Nsz      = max(Nunlobj, Nunlattr);
    
    phi = mxGetField(prhs[0],0,"phi");
    nK  = (int)mxGetScalar(mxGetField(prhs[0],0,"K"));
    K1  = (int)mxGetScalar(mxGetField(prhs[0],0,"K1"));
    N   = (int)mxGetScalar(mxGetField(prhs[0],0,"N"));
    V   = (int)mxGetScalar(mxGetField(prhs[0],0,"V"));
    MAXNUMLABELS = Nsz*(K1+1);
    
    option  = (int)mxGetScalar(prhs[3]);
    windex  = mxGetField(prhs[1],0,"windex");
    wcount  = mxGetField(prhs[1],0,"wcount");
    annotations = mxGetPr(prhs[5]);
    
    plhs[0] = mxCreateDoubleMatrix(1,MAXNUMLABELS,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1,MAXNUMLABELS,mxREAL);
    plhs[2] = mxCreateDoubleMatrix(1,MAXNUMLABELS,mxREAL);
    
    EEP_val   = mxGetPr(plhs[0]);
    imgindex  = mxGetPr(plhs[1]);
    attrindex = mxGetPr(plhs[2]);
     
    numlabels = 0;      
    // loop over each image
    for (int n = 0; n < Nsz; n++)
    {        
        // get data about the current image
	tempn   = unlobj[n];                                               // get the image index
        windexn = mxGetPr(mxDuplicateArray (mxGetCell (windex, tempn)));   // pointer to windex{n}
        wcountn = mxGetPr(mxDuplicateArray (mxGetCell (wcount, tempn)));   // pointer to wcount{n}
        phin    = mxDuplicateArray (mxGetCell (phi, tempn));               // pointer to phi{n}     
 
        k1 = 0;
        if(option==1 || option==3)  
        {
         k1 = K1;
        }       
  
        // for each annotation and class label 
        while (k1 < (K1+1))
        {
            count  = 0;            
            if((k1<K1 && unlattr[tempn, k1]==0) || (k1==K1 && unlclass[tempn]==0)) 
            {          
             while(count<MAXCOUNT)
             {    
              update_phin(temp_phin, phin, windexn, wcountn, model, data, psigamma, tempn, annotations, option, k1);
              update_gamman(temp_gamman, phin, windexn, wcountn, model, data, tempn, annotations, option);
              count++;
             }
            }
            // get the expected entropy reudction  
            EEP_val[numlabels]   = cal_EER(model, data, temp_phin, temp_gamman);
            imgindex[numlabels]  = tempn;
            attrindex[numlabels] = k1;
            numlabels++;     
            k1++;
        }
    }
    // sorting and active selection done in matlab for ease of implementation
    return;
}


// baselines: 
// 1. random query over class labels only (model that does not use annotations at all)
// 2. random query over both annotations and class labels
// 3. DSLDA: query over class labels only (model that does not use annotations at all)
// 4. query over both annotaions and class labels

