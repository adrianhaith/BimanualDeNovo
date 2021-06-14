function stage = get_complexity(stage)
% compute the complexity of a given stage of a rubik's cube solution method
%
% input: stage.case_probs_inv - vector of inverse probabilities [1/N_i]
% associated with a given algorithm

stage.case_probs = 1./stage.case_probs_inv;
stage.case_probs_norm = stage.case_probs/sum(stage.case_probs);

stage.H_actions = -sum(stage.case_probs_norm.*log2(stage.case_probs_norm));

stage.complexity = stage.H_actions;
