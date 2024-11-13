function Q=strats01(g,p1,p2)
	% load strategies, compute cross-strat payoff matrix
	% 1: never shoot
	% 2: always shoot
	% 3: grim never shoot

	% PO(m,n) is payoff of m-th strat when played against n-th strat
	Q(1,1)=gpayoffs01(g,p1,p2,0,0);
	Q(1,2)=gpayoffs01(g,p1,p2,0,1);
	Q(1,3)=gpayoffs01(g,p1,p2,0,0);
	Q(2,1)=gpayoffs01(g,p1,p2,1,0);
	Q(2,2)=gpayoffs01(g,p1,p2,1,1);
	Q(2,3)=p1*1/(1-g)+(1-p1)*gpayoffs01(g,p1,p2,1,1);
	Q(3,1)=gpayoffs01(g,p1,p2,0,0);
	Q(3,2)=p2*0+(1-p2)*gpayoffs01(g,p1,p2,1,1);
	Q(3,3)=gpayoffs01(g,p1,p2,0,0);
end
