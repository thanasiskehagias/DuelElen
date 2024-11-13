% criterion: when Cr1>0, Cr2>0, (grim,grim) is a NE
function [Cr1,Cr2]= crits01(p1,p2,a,b)
	Cr1=(b/a)-(p1*(1+p2*(1-p1)))/(p2*(1-p1));
	Cr2=(b/a)-(p2*(1+p1*(1-p2)))/(p1*(1-p2));
end
