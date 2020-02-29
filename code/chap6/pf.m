%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 基本粒子滤波算法
function [Xo,Xoset]=pf(Xiset,Z,N,k,R,g1,g2)
 
tic
 
resamplingScheme=1;
 
Zpre=ones(1,N);   
Xsetpre=ones(1,N);  
w = ones(1,N);     

 
for i=1:N
    Xsetpre(i) = feval('ffun',Xiset(i),k) + gengamma(g1,g2);
end;

 
for i=1:N,
    Zpre(i) = feval('hfun',Xsetpre(i),k);
    w(i) = inv(sqrt(R)) * exp(-0.5*inv(R)*((Z-Zpre(i))^(2))) ...
        + 1e-99; 
end;
w = w./sum(w);             
 
if resamplingScheme == 1
    outIndex = residualR(1:N,w');       
elseif resamplingScheme == 2
    outIndex = systematicR(1:N,w');  
else
    outIndex = multinomialR(1:N,w');  
end;

 
Xoset = Xsetpre(outIndex); 
Xo=mean(Xoset);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


