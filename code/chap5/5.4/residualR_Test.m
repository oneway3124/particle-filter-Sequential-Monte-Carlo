%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 残差重采样测试程序
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function residualR_Test
rand('seed',1);          
error('下面的参数N请参考书中的值设置，然后删除本行代码')
N=0;                 
A=[2,8,2,7,3,5,5,1,4,6];  
IndexA=1:N               
W=A./sum(A)               
 
DiedaiNumber=8;
V=[];
 
AA=A;
WW=W;
for k=1:DiedaiNumber
   
    outIndex = residualR(WW);
    
    AA=AA(outIndex);
    
    WW=AA./sum(AA)
   
    V=[V;AA];
end
V
 
figure
subplot(2,1,1);
plot(W','--ro','MarkerFace','g');
xlabel('index');ylabel('Value of W');
subplot(2,1,2);
plot(V(1,:)','--ro','MarkerFace','g');
xlabel('index');ylabel('Value of V');
 
function outIndex = residualR(weight)
N= length(weight);
N_babies= zeros(1,N);
q_res = N.*weight;
N_babies = fix(q_res);
N_res=N-sum(N_babies);
if (N_res~=0)
    q_res=(q_res-N_babies)/N_res;
    cumDist= cumsum(q_res);
    u = fliplr(cumprod(rand(1,N_res).^(1./(N_res:-1:1))));
    j=1;
    for i=1:N_res
        while (u(1,i)>cumDist(1,j))
            j=j+1;
        end
        N_babies(1,j)=N_babies(1,j)+1;
    end;
end;
index=1;
for i=1:N
    if (N_babies(1,i)>0)
        for j=index:index+N_babies(1,i)-1
            outIndex(j) = i;
        end;
    end;
    index= index+N_babies(1,i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
