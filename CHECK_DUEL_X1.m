
% Υπολογισμός των απολαβών για J γενεές
total_payoff_p1 = 0;
total_payoff_p2 = 0;

for generation = 1:J
    [payoff_p1, payoff_p2, state_p1, state_p2] = Duel(1, 2, x1, x2, [0 p_1; p_2 0], T, @SelectStrategy, @Strat, [1 1], a, b, p_1, p_2);
	STATE(generation,:)=[state_p1, state_p2];
    
    total_payoff_p1 = total_payoff_p1 + payoff_p1;
    total_payoff_p2 = total_payoff_p2 + payoff_p2;
    
    %fprintf('Generation %d:\n', generation);
    %fprintf('  State of Player 1: %d, Payoff: %.2f\n', state_p1, payoff_p1);
    %fprintf('  State of Player 2: %d, Payoff: %.2f\n', state_p2, payoff_p2);
end

avg_payoff_p1=total_payoff_p1 / J;
avg_payoff_p2=total_payoff_p2 / J;
[thc_payoff_p1,thc_payoff_p2]=payoffs1(p_1,p_2,a,b,x1,x2);

disp([thc_payoff_p1,thc_payoff_p2])
disp([avg_payoff_p1,avg_payoff_p2])

% Συνάρτηση Duel
function [payoff_p1, payoff_p2, state_p1, state_p2] = Duel(p1, p2, x1, x2, PP, T, SelectStrategy, Strat, str_vector, a, b, p_1, p_2)
    str1 = SelectStrategy(p1, str_vector);
    str2 = SelectStrategy(p2, str_vector);
    state_p1 = 1; % Αρχική κατάσταση: 1 = ζωντανός
    state_p2 = 1; % Αρχική κατάσταση: 1 = ζωντανός
    actions = zeros(T, 2);
    killFlag = [0 0];

    %fprintf('Duel between Player %d (%s) and Player %d (%s)\n', p1, str1, p2, str2);

    for t = 1:T
        if state_p1 > 0 && state_p2 > 0
            actions(t,1) = Strat(actions(1:t,1), actions(1:t,2), str1, x1);
            actions(t,2) = Strat(actions(1:t,2), actions(1:t,1), str2, x2);

            % Determine if Player 1 hits Player 2
            if actions(t,1) == 1 && rand < PP(p1, p2)
                state_p2 = 0; % Player 2 is killed
                killFlag(1) = 1; % Player 1 scores a kill
            end

            % Determine if Player 2 hits Player 1
            if actions(t,2) == 1 && rand < PP(p2, p1)
                state_p1 = 0; % Player 1 is killed
                killFlag(2) = 1; % Player 2 scores a kill
            end

            % Print the current state of each player after the round
            %fprintf('Round %d: State of Player 1: %d, State of Player 2: %d\n', t, state_p1, state_p2);
        end

        % Check if any player is dead, break if true
        if state_p1 == 0 || state_p2 == 0
            break;
        end
    end

    % Compute payoffs based on cases
    if killFlag(1) == 1 && killFlag(2) == 0
        payoff_p1 = a; % Player 1 killed Player 2
    elseif killFlag(1) == 0 && killFlag(2) == 1
        payoff_p1 = -b; % Player 1 was killed by Player 2
    elseif killFlag(1) == 1 && killFlag(2) == 1
        payoff_p1 = a - b; % Both players killed each other
    else
        payoff_p1 = 0;
    end

    if killFlag(2) == 1 && killFlag(1) == 0
        payoff_p2 = a; % Player 2 killed Player 1
    elseif killFlag(2) == 0 && killFlag(1) == 1
        payoff_p2 = -b; % Player 2 was killed by Player 1
    elseif killFlag(1) == 1 && killFlag(2) == 1
        payoff_p2 = a - b; % Both players killed each other
    else
        payoff_p2 = 0;
    end
end

function action = Strat(~, ~, strategy, x)
    if strcmp(strategy, 'ProbabilisticShoot') && rand < x
        action = 1; % Ο παίκτης πυροβολεί με πιθανότητα x
    else
        action = 0; % Ο παίκτης δεν πυροβολεί
    end
end

function strategy = SelectStrategy(~, ~)
    strategy = 'ProbabilisticShoot'; % Επιστρέφει τη στρατηγική ProbabilisticShoot για έλεγχο
end

