// Phi(s) = sum_a f_a Psi(x^{a+s}) for all monomials s of degree D in 10 vars.
// Psi(x^h) = prod_j W[h_j] * tab[code], zero if some h_j%3==2, code bit j set iff h_j%3==0.
// usage: phi D W.bin tab.bin terms.bin out.bin   (terms: n records of 10 uint8 + uint32 coeff, little endian)
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#define M 10
static const uint64_t P=31981;
static int64_t W[128]; static int64_t TAB[1024];
static int D; static uint64_t *acc; static int32_t *keyidx; static int npow[M+1];
static uint8_t a[M]; 
static void dfs(int j,int rem,uint64_t w,int code,int key){
  if(j==M-1){int s=rem; int h=a[j]+s; if(h%3==2)return; uint64_t ww=w*W[h]%P; int c=code|((h%3==0)<<j);
    int k=key+s*npow[j]; acc[keyidx[k]]+=ww*TAB[c]%P; return;}
  for(int s=0;s<=rem;s++){int h=a[j]+s; if(h%3==2)continue; if(W[h]==0)continue;
    dfs(j+1,rem-s,w*W[h]%P,code|((h%3==0)<<j),key+s*npow[j]);}
}
int main(int argc,char**argv){
  D=atoi(argv[1]);
  FILE*f=fopen(argv[2],"rb"); fread(W,8,128,f); fclose(f);
  f=fopen(argv[3],"rb"); fread(TAB,8,1024,f); fclose(f);
  int B=D+1; npow[0]=1; for(int j=1;j<=M;j++)npow[j]=npow[j-1]*B;
  keyidx=malloc(sizeof(int32_t)*npow[M]);
  // enumerate degree-D monomials in lex order of the key generation (index assigned in increasing key order)
  int nm=0; for(int k=0;k<npow[M];k++){int t=k,d=0; for(int j=0;j<M;j++){d+=t%B;t/=B;} keyidx[k]=(d==D)?nm++:-1;}
  acc=calloc(nm,8);
  f=fopen(argv[4],"rb"); uint8_t rec[14]; long n=0;
  while(fread(rec,1,14,f)==14){ for(int j=0;j<M;j++)a[j]=rec[j]; uint32_t c; c=rec[10]|(rec[11]<<8)|(rec[12]<<16)|((uint32_t)rec[13]<<24);
    dfs(0,D,c%P,0,0); n++; if((n&0xffff)==0) for(int i=0;i<nm;i++)acc[i]%=P; }
  fclose(f);
  for(int i=0;i<nm;i++)acc[i]%=P;
  f=fopen(argv[5],"wb"); fwrite(acc,8,nm,f); fclose(f);
  fprintf(stderr,"terms %ld monomials %d\n",n,nm); return 0;
}
