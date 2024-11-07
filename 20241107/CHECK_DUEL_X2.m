
num_x1 = floor(N / 2); % Αριθμός παικτών με στρατηγική x1
num_x2 = ceil(N / 2);  % Αριθμός παικτών με στρατηγική x2
end_generation = J;
gameEnded = false;

for generation = 1:J
    % Δημιουργία ομάδων ανά στρατηγική
    team_1 = 1:num_x1; % Παίκτες με στρατηγική x1
    team_2 = num_x1 + 1:N; % Παίκτες με στρατηγική x2

    % Αρχικοποίηση συνολικών payoffs
    generation_payoffs = zeros(1, N); % Απολαβές ανά γενεά
    total_payoff_x1 = 0;
    total_payoff_x2 = 0;

    % Πλήρες ματς
    for i = 1:N-1
        for j = i+1:N
            % Ορισμός πιθανότητας πυροβολισμού ανάλογα με την ομάδα
            if ismember(i, team_1)
                xi = x1;
            else
                xi = x2;
            end
            if ismember(j, team_1)
                xj = x1;
            else
                xj = x2;
            end

            % Διεξαγωγή του ματς μεταξύ του παίκτη i και του παίκτη j
            [payoff_i, payoff_j, ~, ~] = Duel(i, j, xi, xj, [0 p_1; p_2 0], T, @SelectStrategy, @Strat, [1 1], a, b, p_1, p_2);

            % Ενημέρωση απολαβών της γενεάς
            generation_payoffs(i) = generation_payoffs(i) + payoff_i;
            generation_payoffs(j) = generation_payoffs(j) + payoff_j;
        end
    end

    % Προσθήκη της απολαβής ανά στρατηγική
    total_payoff_x1 = sum(generation_payoffs(team_1));
    total_payoff_x2 = sum(generation_payoffs(team_2));

    %{
    % Εμφάνιση των payoffs πριν την κανονικοποίηση
    %fprintf('Γενεά %d:\n', generation);
    
    fprintf('  Αριθμός παικτών με στρατηγική x1: %d\n', num_x1);
    fprintf('  Αριθμός παικτών με στρατηγική x2: %d\n', num_x2);

    fprintf('  Συνολικά payoffs πριν την κανονικοποίηση:\n');
    fprintf('    Στρατηγική x1: %.4f\n', total_payoff_x1);
    fprintf('    Στρατηγική x2: %.4f\n', total_payoff_x2);
    %}

    % Εκθετική κανονικοποίηση των payoffs των στρατηγικών
    exp_payoffs = exp([total_payoff_x1, total_payoff_x2]);
    sum_exp_payoffs = sum(exp_payoffs);
    normalized_payoffs = exp_payoffs / sum_exp_payoffs;

    % Εμφάνιση των κανονικοποιημένων ποσοστών
    %fprintf('  Κανονικοποιημένα ποσοστά: [%.4f, %.4f]\n', normalized_payoffs(1), normalized_payoffs(2));

    % Υπολογισμός του νέου αριθμού παικτών σε κάθε στρατηγική για την επόμενη γενεά
    num_x1 = round(N * normalized_payoffs(1));
    num_x2 = N - num_x1; % Οι υπόλοιποι παίκτες θα έχουν τη στρατηγική x2

    % Αν όλοι οι παίκτες έχουν την ίδια στρατηγική
    if num_x1 == N || num_x2 == N
        gameEnded = true;
        end_generation = generation;
        break;
    else
        end_generation = generation;
    end

end

if gameEnded
    fprintf('Τελικά κανονικοποιημένα ποσοστά απολαβών: [%.4f, %.4f]\n', normalized_payoffs(1), normalized_payoffs(2));
end
if normalized_payoffs(1) > normalized_payoffs(2)
    fprintf('Νικήτρια στρατηγική: x1 στη γενεά %d\n', end_generation);
else
    fprintf('Νικήτρια στρατηγική: x2 στη γενεά %d\n', end_generation);
end


% Συνάρτηση Duel
function [payoff_p1, payoff_p2, state_p1, state_p2] = Duel(p1, p2, x1, x2, PP, T, SelectStrategy, Strat, str_vector, a, b, p_1, p_2)
str1 = SelectStrategy(p1, str_vector);
str2 = SelectStrategy(p2, str_vector);
state_p1 = 1; % Αρχική κατάσταση: 1 = ζωντανός
state_p2 = 1; % Αρχική κατάσταση: 1 = ζωντανός
actions = zeros(T, 2);
killFlag = [0 0];

for t = 1:T
    if state_p1 > 0 && state_p2 > 0
        actions(t,1) = Strat(actions(1:t,1), actions(1:t,2), str1, x1);
        actions(t,2) = Strat(actions(1:t,2), actions(1:t,1), str2, x2);

        % Αν ο παίκτης 1 πυροβολεί τον 2
        if actions(t,1) == 1 && rand < p_1
            state_p2 = 0; % Ο παίκτης 2 σκοτώνεται
            killFlag(1) = 1;
        end

        % Αν ο παίκτης 2 πυροβολεί τον 1
        if actions(t,2) == 1 && rand < p_2
            state_p1 = 0; % Ο παίκτης 1 σκοτώνεται
            killFlag(2) = 1;
        end
    end

    % Αν κάποιος είναι νεκρός τερματίζεται
    if state_p1 == 0 || state_p2 == 0
        break;
    end
end

% Compute payoffs based on cases
if killFlag(1) == 1 && killFlag(2) == 0
    payoff_p1 = a; % Ο παίκτης 1 σκότωσε τον 2
elseif killFlag(1) == 0 && killFlag(2) == 1
    payoff_p1 = -b; %Ο παίκτης 1 σκοτώθηκε από τον 2
elseif killFlag(1) == 1 && killFlag(2) == 1
    payoff_p1 = a - b; % Και οι 2 παίκτες έχουν σκοτώσει τον αντίπαλο
else
    payoff_p1 = 0;
end

if killFlag(2) == 1 && killFlag(1) == 0
    payoff_p2 = a; % Ο παίκτης 2 σκότωσε τον 1
elseif killFlag(2) == 0 && killFlag(1) == 1
    payoff_p2 = -b; % Ο παίκτης 2 σκοτώθηκε από τον 1
elseif killFlag(1) == 1 && killFlag(2) == 1
    payoff_p2 = a - b; % Και οι 2 παίκτες έχουν σκοτώσει τον αντίπαλο
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