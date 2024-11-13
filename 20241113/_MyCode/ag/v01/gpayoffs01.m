% payoff function with stationary strats (x1,x2)
function Q= gpayoffs01(g,p1,p2,x1,x2)
	Q = (-p2*x2 + 1)*(1 - g*(-p1*x1 + 1))/((1 - g)*(1 - g*(-p1*x1 + 1)*(-p2*x2 + 1)));
end
