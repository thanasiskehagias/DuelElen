clear;
clc;

% Αρχικοποίηση παραμέτρων
N = 10; % Αριθμός παικτών
a = 0.1; % Απόλαβη αν ο παίκτης σκοτώσει τον άλλο
b = 0.08; % Απόλαβη αν σκοτωθεί ο παίκτης
p_1 = 0.05; % Πιθανότητα ευστοχίας παίκτη 1
p_2 = 0.05; % Πιθανότητα ευστοχίας παίκτη 2
x1 = 0.4; % Πιθανότητα πυροβολισμού για την πρώτη ομάδα
x2 = 0.25; % Πιθανότητα πυροβολισμού για τη δεύτερη ομάδα
T = 100; % Αριθμός γύρων
J = 1000; % Αριθμός γενεών 


CHECK_DUEL_X2