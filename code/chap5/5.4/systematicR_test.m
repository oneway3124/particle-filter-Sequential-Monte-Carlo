%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 系统重采样测试程序
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function systematicR_test
rand('seed',1);       
error('下面的参数N请参考书中的值设置，然后删除本行代码')
N=0;                    
A=[2,8,2,7,3,5,5,1,4,6];  
IndexA=1:N               
W=A./sum(A)              
 
DiedaiNumber=7;
V=[];
 
AA=A;
WW=W;
for k=1:DiedaiNumber
 
    outIndex = systematicR(WW);
   
    AA=AA(outIndex);
    
    WW=AA./sum(AA)
    
    V=[V;AA];
end
V
 
figure
subplot(2,1,1);
plot(W','--ro','MarkerFace','g');
legend('原始随机样本集W');
subplot(2,1,2);
plot(V(1,:)','--ro','MarkerFace','g');
legend('重采样后样本集V');
 
function outIndex = systematicR(weight);
 
 
N=length(weight);
N_children=zeros(1,N);
label=zeros(1,N);
label=1:1:N;
s=1/N;
auxw=0;
auxl=0;
li=0;
T=s*rand(1);
j=1;
Q=0;
i=0;
u=rand(1,N);
while (T<1)
    if (Q>T)
        T=T+s;
        N_children(1,li)=N_children(1,li)+1;
    else
        i=fix((N-j+1)*u(1,j))+j;
        auxw=weight(1,i);
        li=label(1,i);
        Q=Q+auxw;
        weight(1,i)=weight(1,j);
        label(1,i)=label(1,j);
        j=j+1;
    end
end
index=1;
for i=1:N
    if (N_children(1,i)>0)
        for j=index:index+N_children(1,i)-1
            outIndex(j) = i;
        end;
    end;
    index= index+N_children(1,i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
