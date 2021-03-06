%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 产生一个符合gamma分布的噪声
function x = gengamma(alpha, beta)
 
if (alpha==1)
    x = -log(1-rand(1,1))/beta;
    return
end
flag=0;
if (alpha<1)  
    flag=1;
    alpha=alpha+1;
end
gamma=alpha-1;
eta=sqrt(2.0*alpha-1.0);
c=.5-atan(gamma/eta)/pi;
aux=-.5;
while(aux<0)
    y=-.5;
    while(y<=0)
        u=rand(1,1);
        y = gamma + eta * tan(pi*(u-c)+c-.5);
    end
    v=-log(rand(1,1));
    aux=v+log(1.0+((y-gamma)/eta)^2)+gamma*log(y/gamma)-y+gamma;
end;

 
if (flag==1) 
    x = y/beta*(rand(1))^(1.0/(alpha-1));
else
    x = y/beta;
end