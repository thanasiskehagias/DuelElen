% player-centric duels evolutionary tournament with theoretical payoffs  -- a=1,b=0, g in (0,1)
clear all; clc

% parameters
g=0.90;
p=0.95;			% kill probability
p=0.15;			% kill probability
K=10.00;		% fitness constant
J=50;			% number of generations
PRP=[10 10 10];	% initial strategy distribution
%PRP=[50 20 80];	% initial strategy distribution

% load strategies
Q=gstrats01(g,p,p);
M=size(Q,1);

% initial strategy distribution
STR=[]; for m=1:M; STR=[STR m*ones(1,PRP(m))]; end; N=size(STR,2);

% main
for j=1:J
	for n1=1:N
		sc(j,n1)=0;
		for n2=1:N 
			sc(j,n1)=sc(j,n1)+Q(STR(j,n1),STR(j,n2));
		end
	end

	for m=1:M 
		q1=find(STR(j,:)==m);
		PRP(j,m)=length(q1);
		SCR(j,m)=sum(sc(j,q1));
	end
	SCR(j,:)=SCR(j,:)/N;
	FIT(j,:)=gfit01(SCR(j,:),K);
	STR(j+1,:)=randsample([1:M],N,true,FIT(j,:));
	disp([SCR(j,:) FIT(j,:)])
	%pause
end
figure(1); plot(SCR); grid
axis([1 J -1.0 max(max(SCR))]); legend('never shoot','always shoot','grim never shoot','Location','southeast')
figure(2); plot(FIT); grid
axis([1 J -0.1 1.1]); legend('never shoot','always shoot','grim never shoot','Location','southeast')

