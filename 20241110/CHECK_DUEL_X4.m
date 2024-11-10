
%% GRIM - ALWAYS (ΕΥΣΤΟΧΙΑ ΣΤΡΑΤΗΓΙΚΩΝ)
%% Πολλαπλά πειράματα, αποθήκευση σε text
num_experiments = 100;
grim_wins = 0;
always_shoot_wins = 0;

fileID = fopen('results.txt', 'w');

for experiment = 1:num_experiments
    num_grim = floor(N / 2); % Αρχικός αριθμός παικτών με στρατηγική Grim
    num_always_shoot = ceil(N / 2); % Αρχικός αριθμός παικτών με στρατηγική Always Shoot
    end_generation = J;
    gameEnded = false;

    for generation = 1:J

        % Δημιουργία του διανύσματος στρατηγικών για αυτήν τη γενεά
        str_vector = [repmat({'Grim'}, 1, num_grim), repmat({'AlwaysShoot'}, 1, num_always_shoot)];
     %{   
% Τυπώνουμε τις πιθανότητες ευστοχίας και τη στρατηγική κάθε παίκτη στην αρχή της γενεάς
    fprintf('Γενεά %d: Πιθανότητες ευστοχίας και στρατηγική κάθε παίκτη\n', generation);
    for player = 1:N
        if player <= num_grim
            fprintf('  Παίκτης %d: Πιθανότητα ευστοχίας = %.2f, Στρατηγική = Grim\n', player, p_1);
        else
            fprintf('  Παίκτης %d: Πιθανότητα ευστοχίας = %.2f, Στρατηγική = Always Shoot\n', player, p_2);
        end
    end

        %}
        
        %{
        fprintf('Γενεά %d: Στρατηγική κάθε παίκτη στην αρχή της γενεάς\n', generation);
        for player = 1:N
           fprintf('  Παίκτης %d: Στρατηγική %s\n', player, str_vector{player});
        end
        %}      

        % Αρχικοποίηση συνολικών payoffs
        generation_payoffs = zeros(1, N); % Απολαβές ανά γενεά
        total_payoff_grim = 0;
        total_payoff_always_shoot = 0;

        % Πλήρες ματς
        for i = 1:N-1
            for j = i+1:N
                % Διεξαγωγή του ματς μεταξύ του παίκτη i και του παίκτη j
                [payoff_i, payoff_j, ~, ~] = Duel(i, j, T, @SelectStrategy, @Strat, str_vector, a, b, p_1, p_2);

                % Ενημέρωση απολαβών της γενεάς
                generation_payoffs(i) = generation_payoffs(i) + payoff_i;
                generation_payoffs(j) = generation_payoffs(j) + payoff_j;
            end
        end

        % Προσθήκη της απολαβής ανά στρατηγική
        total_payoff_grim = sum(generation_payoffs(1:num_grim));
        total_payoff_always_shoot = sum(generation_payoffs(num_grim+1:end));

        % Εκθετική κανονικοποίηση των payoffs των στρατηγικών
        exp_payoffs = exp([total_payoff_grim, total_payoff_always_shoot]);
        sum_exp_payoffs = sum(exp_payoffs);
        normalized_payoffs = exp_payoffs / sum_exp_payoffs;

        %fprintf('Γενεά %d: Κανονικοποιημένα ποσοστά απολαβών\n', generation);
        %fprintf('  Grim: %.4f\n', normalized_payoffs(1));
        %fprintf('  Always Shoot: %.4f\n', normalized_payoffs(2));


        % Υπολογισμός του νέου αριθμού παικτών σε κάθε στρατηγική για την επόμενη γενεά
        num_grim = round(N * normalized_payoffs(1));
        num_always_shoot = N - num_grim; % Οι υπόλοιποι παίκτες θα έχουν τη στρατηγική Always Shoot

        % Αν όλοι οι παίκτες έχουν την ίδια στρατηγική
        if num_grim == N || num_always_shoot == N
            gameEnded = true;
            end_generation = generation;
            break;
        else
            end_generation = generation;
        end
    end

    % Καταγραφή της νικήτριας στρατηγικής για το τρέχον πείραμα
    if normalized_payoffs(1) > normalized_payoffs(2)
        grim_wins = grim_wins + 1;
        fprintf(fileID, 'Πείραμα %d: Νικήτρια στρατηγική: Grim στη γενεά %d\n', experiment, end_generation);
    else
        always_shoot_wins = always_shoot_wins + 1;
        fprintf(fileID, 'Πείραμα %d: Νικήτρια στρατηγική: Always Shoot στη γενεά %d\n', experiment, end_generation);
    end
end

% Υπολογισμός ποσοστού νικών κάθε στρατηγικής
total_experiments = grim_wins + always_shoot_wins;
grim_win_percentage = (grim_wins / total_experiments) * 100;
always_shoot_win_percentage = (always_shoot_wins / total_experiments) * 100;

fprintf(fileID, '\nΣυνολικές νίκες:\n');
fprintf(fileID, 'Grim: %d νίκες (%.2f%%)\n', grim_wins, grim_win_percentage);
fprintf(fileID, 'Always Shoot: %d νίκες (%.2f%%)\n', always_shoot_wins, always_shoot_win_percentage);

fclose(fileID);

fprintf('\nΣυνολικές νίκες:\n');
fprintf('Grim: %d νίκες (%.2f%%)\n', grim_wins, grim_win_percentage);
fprintf('Always Shoot: %d νίκες (%.2f%%)\n', always_shoot_wins, always_shoot_win_percentage);

% Συνάρτηση Duel
function [payoff_p1, payoff_p2, state_p1, state_p2] = Duel(p1, p2, T, SelectStrategy, Strat, str_vector, a, b, p_1, p_2)
str1 = SelectStrategy(p1, str_vector);
str2 = SelectStrategy(p2, str_vector);
state_p1 = 1; % Αρχική κατάσταση: 1 = ζωντανός
state_p2 = 1; % Αρχική κατάσταση: 1 = ζωντανός
memory_i = false;
memory_j = false;
killFlag = [0 0];

for t = 1:T
    action_i = Strat(memory_i, str1, p_1); % Δράση για τον παίκτη 1
    action_j = Strat(memory_j, str2, p_2); % Δράση για τον παίκτη 2

     % Δράση κάθε παίκτη στον τρέχοντα γύρο
        %fprintf('Γύρος %d - Παίκτης %d: Δράση = %d, Παίκτης %d: Δράση = %d\n', t, p1, action_i, p2, action_j);

    % Αν ο παίκτης i πυροβολεί τον j
    if action_i && rand < p_1
        state_p2 = 0; % Ο παίκτης j σκοτώνεται
        killFlag(1) = 1;
    end

    % Αν ο παίκτης j πυροβολεί τον i
    if action_j && rand < p_2
        state_p1 = 0; % Ο παίκτης i σκοτώνεται
        killFlag(2) = 1;
    end

    % Ενημέρωση μνήμης Grim αν πυροβοληθούν
    if action_j && ~memory_i
        memory_i = true; % Ο παίκτης i πυροβολήθηκε, άρα θα πυροβολεί πάντα από εδώ και πέρα
    end
    if action_i && ~memory_j
        memory_j = true; % Ο παίκτης j πυροβολήθηκε, άρα θα πυροβολεί πάντα από εδώ και πέρα
    end

    % Αν κάποιος είναι νεκρός, τερματίζεται
    if state_p1 == 0 || state_p2 == 0
        break;
    end
end

% Υπολογισμός απολαβών
if killFlag(1) == 1 && killFlag(2) == 0
    payoff_p1 = a; % Ο παίκτης 1 σκότωσε τον 2
elseif killFlag(1) == 0 && killFlag(2) == 1
    payoff_p1 = -b; % Ο παίκτης 1 σκοτώθηκε από τον 2
elseif killFlag(1) == 1 && killFlag(2) == 1
    payoff_p1 = a - b; % Και οι δύο παίκτες σκότωσαν τον αντίπαλο
else
    payoff_p1 = 0;
end

if killFlag(2) == 1 && killFlag(1) == 0
    payoff_p2 = a; % Ο παίκτης 2 σκότωσε τον 1
elseif killFlag(2) == 0 && killFlag(1) == 1
    payoff_p2 = -b; % Ο παίκτης 2 σκοτώθηκε από τον 1
elseif killFlag(1) == 1 && killFlag(2) == 1
    payoff_p2 = a - b; % Και οι δύο παίκτες σκότωσαν τον αντίπαλο
else
    payoff_p2 = 0;
end
end

% Συνάρτηση Strat για τον καθορισμό της δράσης ανά στρατηγική
function action = Strat(memory, strategy, p)
if strcmp(strategy, 'Grim')
    action = memory; % Ο παίκτης Grim πυροβολεί μόνο αν έχει δεχτεί πυροβολισμό
elseif strcmp(strategy, 'AlwaysShoot')
    action = 1; % Ο AlwaysShoot πυροβολεί πάντα
else
    action = rand < p; % Στρατηγική με πιθανότητα πυροβολισμού
end
end

% Συνάρτηση SelectStrategy για επιλογή στρατηγικής
function strategy = SelectStrategy(player, str_vector)
strategy = str_vector{player}; % Επιστρέφει τη στρατηγική που αντιστοιχεί στον παίκτη
end