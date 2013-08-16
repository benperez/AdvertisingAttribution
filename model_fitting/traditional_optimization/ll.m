function [ log_likelihood ] = ll(b120,b12gi,b12si,b12gc,b12sc,b12src,b130,b13gi,b13si,b13gc,b13sc,b13src,b210,b21gi,b21si,b21gc,b21sc,b21src,b230,b23gi,b23si,b23gc,b23sc,b23src,b310,b31gi,b31si,b31gc,b31sc,b31src,b320,b32gi,b32si,b32gc,b32sc,b32src,t2n,t2gi,t2si,t2gc,t2sc,t2src,t3n,t3gi,t3si,t3gc,t3sc,t3src,g2a,g2gi,g2si,g2gc,g2sc,g2src,g2nw,g3a,g3gi,g3si,g3gc,g3sc,g3src,g3nw,cit,nit,xprime)

b_12 = [b120,b12gi,b12si,b12gc,b12sc,b12src];
b_13 = [b130,b13gi,b13si,b13gc,b13sc,b13src];
b_21 = [b210,b21gi,b21si,b21gc,b21sc,b21src];
b_23 = [b230,b23gi,b23si,b23gc,b23sc,b23src];
b_31 = [b310,b31gi,b31si,b31gc,b31sc,b31src];
b_32 = [b320,b32gi,b32si,b32gc,b32sc,b32src];
t_2 = [t2n,t2gi,t2si,t2gc,t2sc,t2src];
t_3 = [t2n+exp(t3n),t3gi,t3si,t3gc,t3sc,t3src];
g_2 = [g2a,g2gi,g2si,g2gc,g2sc,g2src,g2nw];
g_3 = [g2a+exp(g3a),g3gi,g3si,g3gc,g3sc,g3src,g3nw];

log_likelihood = 0;
[n_users,t_steps] = size(cit);

%sum across users
for i = 1:n_users
    pi_prime = [1,0,0];
    phi_0 = [1,0,0;0,0,0;0,0,0];
    likelihood = pi_prime * phi_0;
    for t = 1:t_steps
        xprime_i = [1,reshape(xprime(i,t,:),1,[])];
        q_it = transition_probabilities(b_12,b_13,b_21,b_23,b_31,b_32,xprime_i);
        phi_it = emission_probabilities(t_2,t_3,g_2,g_3,double(cit(i,t)),double(nit(i,t)),xprime_i);
        likelihood = likelihood * q_it * phi_it;
        if cit(i,t) == 1
            break;
        end
    end
    log_likelihood = log_likelihood - log(likelihood * [1;1;1]);
end

end