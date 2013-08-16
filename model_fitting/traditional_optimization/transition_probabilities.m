function [ q_itss ] = transition_probabilities( b_12,b_13,b_21,b_23,b_31,b_32,xp )
q_itss = zeros(3,3);
sum_1 = exp( dot(b_12,xp) ) + exp( dot(b_13, xp) );
sum_2 = exp( dot(b_21,xp) ) + exp( dot(b_23,xp) );
sum_3 = exp( dot(b_31,xp) ) + exp( dot(b_32,xp) );
q_itss(1,1) = 1 / (1 + sum_1);
q_itss(1,2) = exp( dot(b_12,xp) ) / (1 + sum_1);
q_itss(1,3) = exp( dot(b_13,xp) ) / (1 + sum_1);

q_itss(2,1) = exp( dot(b_21,xp) ) / (1 + sum_2);
q_itss(2,2) = 1 / (1 + sum_2);
q_itss(2,3) = exp( dot(b_23,xp) ) / (1 + sum_2);

q_itss(3,1) = exp( dot(b_31,xp) ) / (1 + sum_3);
q_itss(3,2) = exp( dot(b_32,xp) ) / (1 + sum_3);
q_itss(3,3) = 1 / (1 + sum_3);
end
