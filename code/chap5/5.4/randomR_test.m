%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 随机采样测试程序
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function randomR_test
error('下面的参数N请参考书中的值设置，然后删除本行代码')
N=0;                          
A=[2,8,2,7,3,5,5,1,4,6];            
IndexA=1:N                
W=A./sum(A)                   

 
OutIndex = randomR(W)
 
NewA=A(OutIndex)

 
W=NewA./sum(NewA)
OutIndex = randomR(W)
NewA2=NewA(OutIndex)

 
W=NewA2./sum(NewA2)
OutIndex = randomR(W)
NewA3=NewA2(OutIndex)
             
                              
figure
subplot(2,1,1);
plot(A,'--ro','MarkerFace','g');
axis([1,N,1,N])
subplot(2,1,2);
plot(NewA,'--ro','MarkerFace','g');
axis([1,N,1,N])
 
function outIndex = randomR(weight)
 
L=length(weight)
 
outIndex=zeros(1,L)
 
u=unifrnd(0,1,1,L)
u=sort(u)
 
cdf=cumsum(weight)

 
i=1;
for j=1:L
 
    while (i<=L) & (u(i)<=cdf(j))
 
        outIndex(i)=j;
 
        i=i+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
