function [ phi_it ] = emission_probabilities( t_2,t_3,g_2,g_3,c_it,n_it,xp )
phi_it = zeros(3,3);
phi_it(1,1) = 0^c_it * 0^n_it;
z_it = [xp,n_it];
phi_it(2,2) = exp(c_it * dot(g_2,z_it)) / (1 + exp(dot(g_2,z_it))) * dot(t_2,xp)^n_it * exp(-dot(t_2,xp)) / factorial(n_it);
phi_it(3,3) = exp(c_it * dot(g_3,z_it)) / (1 + exp(dot(g_3,z_it))) * dot(t_3,xp)^n_it * exp(-dot(t_3,xp)) / factorial(n_it);
end

