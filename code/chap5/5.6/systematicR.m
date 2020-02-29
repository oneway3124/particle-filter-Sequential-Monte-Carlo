%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 系统重采样子函数
% 输入参数：weight为原始数据对应的权重大小
% 输出参数：outIndex是根据weight筛选和复制结果
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
