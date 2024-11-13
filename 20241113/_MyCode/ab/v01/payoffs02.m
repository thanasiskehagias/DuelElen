% payoff function with stationary strats (x1,x2)
function [Q1,Q2]= payoffs01(p1,p2,a,b,x1,x2)
	if x1==0 && x2==0
		Q1=0;
		Q2=0;
	else
		Q1 = (x1*p1*a-x2*p2*b)/(p1*x1+p2*x2-p1*x1*p2*x2);
		Q2 = (x2*p2*a-x1*p1*b)/(p1*x1+p2*x2-p1*x1*p2*x2);
	end
end
