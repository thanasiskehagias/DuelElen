function PO=strats01(a,b,p1,p2)
	% load strategies, compute cross-strat payoff matrix
	% 1: never shoot
	% 2: always shoot
	% 3: grim never shoot

	% PO(m,n) is payoff of m-th strat when played against n-th strat
	PO(1,:)=[0,-b,0];
	PO(2,:)=[a,payoffs02(p1,p2,a,b,1,1),p1*a+(1-p1)*payoffs02(p1,p2,a,b,1,1)];
	PO(3,:)=[0,p2*(-b)+(1-p2)*payoffs02(p1,p2,a,b,1,1),0];
end
