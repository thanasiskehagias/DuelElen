% player-centric duels evolutionary tournament with theoretical payoffs  -- a=1,b=0, g in (0,1)
clear all; clc

% parameters
g=0.90;
p=0.5;			% kill probability
K=1.00;			% fitness constant
J=50;			% number of generations
CMP=[10 10 10];	% initial strategy distribution
%CMP=[50 20 80];	% initial strategy distribution

% load strategies
Q=gstrats01(g,p,p);
M=size(Q,1);

% initial strategy distribution
N=sum(CMP);

% main
for j=1:J
	for m=1:M
		SCR(j,m)=0;
		for k=1:M 
			SCR(j,m)=SCR(j,m)+CMP(j,m)*CMP(j,k)*Q(m,k);
		end
	end
	SCR(j,:)=SCR(j,:)/N;
	FIT(j,:)=gfit01(SCR(j,:),K);
	STR(j+1,:)=randsample([1:M],N,true,FIT(j,:));
	for m=1:M 
		CMP(j+1,m)=length(find(STR(j+1,:)==m));
	end
	disp([SCR(j,:) FIT(j,:)])
	%pause
end
figure(1); plot(SCR); grid; title('Strategy Scores');axis([1 J min(min(SCR))-0.2 max(max(SCR))*1.05]); 
legend('never shoot','always shoot','grim never shoot','Location','southeast')
figure(2); plot(CMP); grid; title('Strategy Users');axis([1 J -1 N+1]); 
legend('never shoot','always shoot','grim never shoot','Location','southeast')

