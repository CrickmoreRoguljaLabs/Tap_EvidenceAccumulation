# Tap_EvidenceAccumulation
Code for simulating evidence accumulation for fly courtship
by Stephen Zhang

Code package to simulate the consequences of evidence accumulation during courtship decision.

Scrits:

accum_trials gives a simple sample of 5 flies accumulating evidence to start courtship

Tapping_evidence_accumulation runs the simulation on a larger scale to show the cumulative courtship initiation probabilities after 1-4 taps. The results are surprisingly clos to that of a perfect coin flip.

Courtship_choice_2_female simulates and compares the performance of perfect evidence-accumulators and perfect coin-flippers in courtship choice assay (choosing between 1 virgin and a 1 mated female).

Functions:
tapevid - the main function for evidence accumulation (1 female)
tapevid_2fly - a function to simulate evidence-accumulators' performance in a 2-female choice assay
tapevid_2fly_coin - a function to simulate coin-flippers' performance in a 2-female choice assay
