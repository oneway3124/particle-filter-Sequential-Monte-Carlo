%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outIndex = multinomialR(inIndex,q);
if nargin < 2
error('Not enough input arguments.');
end
[S,arb] = size(q);
N_babies= zeros(1,S);
cumDist= cumsum(q');   
u = fliplr(cumprod(rand(1,S).^(1./(S:-1:1))));
j=1;
for i=1:S
  while (u(1,i)>cumDist(1,j))
    j=j+1;
  end
  N_babies(1,j)=N_babies(1,j)+1;
end;
index=1;
for i=1:S
  if (N_babies(1,i)>0)
    for j=index:index+N_babies(1,i)-1
      outIndex(j) = inIndex(i);
    end;
  end;   
  index= index+N_babies(1,i);   
end
