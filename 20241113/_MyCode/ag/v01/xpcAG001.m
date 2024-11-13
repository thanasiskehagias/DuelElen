% player-centric duels evolutionary tournament with theoretical payoffs  -- a=1,b=0, g in (0,1)
clear all; clc

% parameters
g=0.90;
p=0.95;			% kill probability
p=0.15;			% kill probability
K=10.00;		% fitness constant
J=50;			% number of generations
CMP=[10 10 10];	% initial strategy distribution
%CMP=[50 20 80];	% initial strategy distribution

% load strategies
Q=gstrats01(g,p,p);
M=size(Q,1);

% initial strategy distribution
STR=[]; for m=1:M; STR=[STR m*ones(1,CMP(m))]; end; N=size(STR,2);

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
		CMP(j,m)=length(q1);
		SCR(j,m)=sum(sc(j,q1));
	end
	SCR(j,:)=SCR(j,:)/N;
	FIT(j,:)=gfit01(SCR(j,:),K);
	STR(j+1,:)=randsample([1:M],N,true,FIT(j,:));
	disp([SCR(j,:) FIT(j,:)])
	%pause
end
figure(1); plot(SCR); grid; title('Strategy Scores');axis([1 J min(min(SCR))-0.2 max(max(SCR))*1.05]); 
legend('never shoot','always shoot','grim never shoot','Location','southeast')
figure(2); plot(CMP); grid; title('Strategy Users');axis([1 J -1 N+1]); 
legend('never shoot','always shoot','grim never shoot','Location','southeast')

