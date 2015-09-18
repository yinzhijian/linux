#define swap2(a,b) ({ \
asm __volatile__ ( \
"movl (%0),%%eax; \
xchg (%1),%%eax; \
movl %%eax,(%0)" \
: \
:"r" (a),"r" (b):"%eax"); \
})
int swap(int *a,int *b){
	int c;
	c = *a;*a=*b;*b=c;
}
int main(){
	int a = 31,b=55;
	swap2(&a,&b);
	return (a-b);
}
