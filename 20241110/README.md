# Παρατήρηση για τις Τιμές των Παραμέτρων

**Λόγω της εκθετικής κανονικοποίησης των απολαβών,
ο κώδικας δουλεύει σωστά μόνο για πολύ μικρές τιμές των `b` και `a`
(δεδομένου ότι οι ευστοχίες δεν ορίζονται ως εξαιρετικά μικρές).**

Για να αυξήσω ή να μειώσω την αναλογία των `a` και `b`,
κρατάω πάντα το `b = 0.1` και αυξομειώνω ανάλογα το `a`.
Διαφορετικά, για παράδειγμα με `b = 1`, ακόμη και για πολύ μικρό `a`, προκύπτει λανθασμένα ως
βέλτιστη στρατηγική η **Always Shoot**, καθώς το παίγνιο δεν προλαβαίνει να εξελιχθεί πέρα από την πρώτη γενεά.

Θα προσπαθήσω να υλοποιήσω ξανά τον κώδικα με άλλη μορφή κανονικοποίησης, ώστε να δουλεύει σωστά και με σχετικά μεγαλύτερες τιμές των παραμέτρων.