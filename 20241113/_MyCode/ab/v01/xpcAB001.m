% player-centric duels evolutionary tournament with theoretical payoffs  
% evolution dynamics is by prob change to best performing strategy
clear all; clc

% parameters
a=1; 		% survive gain
b=5; 		% death cost
p=0.20;		% kill probability
J=30;		% number of generations
PrCh=0.1;	% strategy change probability

% load strategies
Q=strats01(a,b,p,p);
M=size(Q,1);
FIT(1,:)=0.5*ones(1,M);

% initial strategy distribution
CMP=[5 5 5]; 
STR=[]; for m=1:M; STR=[STR m*ones(1,CMP(m))]; end; N=size(STR,2);

% main
for j=1:J
	for m=1:M 
		q1=find(STR(j,:)==m);
		CMP(j,m)=length(q1);
	end
	disp([j CMP(j,:)])
	for n1=1:N
		sc(j,n1)=0;
		for n2=1:N 
			sc(j,n1)=sc(j,n1)+Q(STR(j,n1),STR(j,n2));
		end
	end
	[scb(j,1) plb(j,1)]=max(sc(j,:));
	%[q1 q2]=max(sc(j,:)); scb(j,1)=q1; plb(j,1)=q2;
	stb(j,1)=STR(j,plb(j));
	%disp([scb(j) plb(j) stb(j)]);pause
	for n=1:N 
		STR(j+1,n)=STR(j,n);
		if rand(1)<PrCh
			STR(j+1,n)=stb(j);
		end
	end
end
figure(1); plot(CMP); grid; title('Strategy Users');axis([1 J -1 N+1]); 
legend('never shoot','always shoot','grim never shoot','Location','southeast')

[Cr1,Cr2]= crits01(p,p,a,b);
disp([Cr1 Cr2])

