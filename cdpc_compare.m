clc
clear;
noOfNodes = 30;
rand('state', 0);
sig2=0.2e-16;
pmax=1e-3;
%c=550000000;
c=1;
b=10000;
pc=0;
sirsu_tar=5;
%d=r:100:1000;
d=rand(1,noOfNodes)*2000;
d=sort(d);
h=1./(d.^4);
pow_ini=ones(1,noOfNodes)*2.22e-16;
p=pow_ini;
for t=1:80
    pow=p;
for i=1:noOfNodes
    sump(i)=p*h';
    sir(i)=128*p(i)*h(i)/(sump(i)-p(i)*h(i)+sig2);
    %p(i)=(sirsu_tar/sir(i))*pow(i)-c*(pow(i)/sir(i))^2;
    %p(i)=(sirsu_tar/sir(i))*pow(i)-c*(10^(0.05*h(i,j)))*(pow(i)/sir(i));
    %p(i)=(sirsu_tar/sir(i))*pow(i)-g*((h(i)^(-0.25))-(max(h))^(-0.25))*pow(i)/sir(i);
    x(i)=pow(i)/sir(i);
    p(i)=(sirsu_tar/sir(i))*pow(i);
    p(i)=min(p(i),pmax);
    pt(i,t)=pow(i);
    sirt(i,t)=sir(i);
    end
av_pow(t)=sum(p)/noOfNodes;
t1(t)=t;
sir_su(t)=sum(sir)/noOfNodes;
if norm(pow - p) <= 1.0e-20
        break;
end
end
%sump
sir
av_sir=sum(sir)/noOfNodes
av_p=sum(p)/noOfNodes;
p
t;
for i=1:noOfNodes
    prec(i)=p(i)*h(i);
    %jcost(i)=b*p(i)+c*(sirsu_tar-sir(i))^2;
    jcost(i)=(sirsu_tar-sir(i))^(2)+b*p(i);
end
%prec
figure(2)
cc=hsv(noOfNodes);
for i=1:noOfNodes
   % if i==4
subplot(2,4,4)
plot(t1,pt(i,:)*1000,'b - ','LineWidth',1)
%plot(t1,pt(i,:),'b - ')
   xlabel('Iteration')
   ylabel('Power (mW)')
  % legend('User3')
   %title('Equilibrium Power ')
   title('CDPC Algorithm ')
   %box off, axis xy
   axis([0 80 0 1])
  % axis([0 50 0 1e-3])
   hold on
   %grid on
   %subplot(2,2,2)
   subplot(2,4,8)
   plot(t1,sirt(i,:),'b -','LineWidth',1)
   xlabel('Iteration')
   ylabel('SIR')
   title('CDPC Algorithm ')
   % title('Equilibrium SIR ')
  % box off, axis xy
 axis([0 80 0 5])
   hold on
   
   %grid on
    %end
end
%r=ones(1,50)*10;
 %subplot(2,2,3)
%plot(t1,r,'k -','LineWidth',2)
 %  hold on
%  axis([0 20 0 5])
set(gcf, 'Color', 'w');
figure(3)
%subplot(2,2,3)
plot(t1,sir_su,'g -.','LineWidth',2.5,'MarkerSize',5)
   xlabel('Iteration')
   ylabel('Average SIR of D2D')
   %title('Equilibrium Power ')
  % box off, axis xy
   hold on
   grid on
   %axis([0 300 4 5])
   set(gcf, 'Color', 'w');
   figure(4)
%subplot(2,2,3)
plot(t1,av_pow*1000,'g -','LineWidth',3)
   xlabel('Iteration')
   ylabel('Average Power of D2D (mW)')
   %title('Equilibrium Power ')
   %box off, axis xy
   %legend ('CDPC Algorithm')
   hold on
   grid on
   
   %axis([0 300 4 5])
 %  sir=sort(sir)
 p=sort(p);  
 n=1:20;
 set(gcf, 'Color', 'w');
  