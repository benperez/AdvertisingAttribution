clear;
load attribution;

xn = [-5,0,0,0,0,0,-5,0,0,0,0,0,-5,0,0,0,0,0,-5,0,0,0,0,0,-5,0,0,0,0,0,-5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

%Do NR-Optimization
syms b120 b12gi b12si b12gc b12sc b12src b130 b13gi b13si b13gc b13sc b13src b210 b21gi b21si b21gc b21sc b21src b230 b23gi b23si b23gc b23sc b23src b310 b31gi b31si b31gc b31sc b31src b320 b32gi b32si b32gc b32sc b32src t2n t2gi t2si t2gc t2sc t2src t3n t3gi t3si t3gc t3sc t3src g2a g2gi g2si g2gc g2sc g2src g2nw g3a g3gi g3si g3gc g3sc g3src g3nw;
all_syms = [b120 b12gi b12si b12gc b12sc b12src b130 b13gi b13si b13gc b13sc b13src b210 b21gi b21si b21gc b21sc b21src b230 b23gi b23si b23gc b23sc b23src b310 b31gi b31si b31gc b31sc b31src b320 b32gi b32si b32gc b32sc b32src t2n t2gi t2si t2gc t2sc t2src t3n t3gi t3si t3gc t3sc t3src g2a g2gi g2si g2gc g2sc g2src g2nw g3a g3gi g3si g3gc g3sc g3src g3nw];
n_syms = 62;

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

[n_users t_steps] = size(cit);

n_iterations = 20;
tolerance = 10;

%Pre-calculate the gradient, hessian
pi_prime = [1 0 0];
phi_0 = [1 0 0;0 0 0;0 0 0];
likelihood = pi_prime * phi_0;
syms x1_1 x1_2 x1_3 x1_4 x1_5 x1_6;
x1 = [x1_1 x1_2 x1_3 x1_4 x1_5 x1_6];
syms x2_1 x2_2 x2_3 x2_4 x2_5 x2_6;
x2 = [x2_1 x2_2 x2_3 x2_4 x2_5 x2_6];
syms x3_1 x3_2 x3_3 x3_4 x3_5 x3_6;
x3 = [x3_1 x3_2 x3_3 x3_4 x3_5 x3_6];
syms x4_1 x4_2 x4_3 x4_4 x4_5 x4_6;
x4 = [x4_1 x4_2 x4_3 x4_4 x4_5 x4_6];
syms x5_1 x5_2 x5_3 x5_4 x5_5 x5_6;
x5 = [x5_1 x5_2 x5_3 x5_4 x5_5 x5_6];
syms x6_1 x6_2 x6_3 x6_4 x6_5 x6_6;
x6 = [x6_1 x6_2 x6_3 x6_4 x6_5 x6_6];
syms x7_1 x7_2 x7_3 x7_4 x7_5 x7_6;
x7 = [x7_1 x7_2 x7_3 x7_4 x7_5 x7_6];
syms x8_1 x8_2 x8_3 x8_4 x8_5 x8_6;
x8 = [x8_1 x8_2 x8_3 x8_4 x8_5 x8_6];
syms x9_1 x9_2 x9_3 x9_4 x9_5 x9_6;
x9 = [x9_1 x9_2 x9_3 x9_4 x9_5 x9_6];
syms x10_1 x10_2 x10_3 x10_4 x10_5 x10_6;
x10 = [x10_1 x10_2 x10_3 x10_4 x10_5 x10_6];
syms x11_1 x11_2 x11_3 x11_4 x11_5 x11_6;
x11 = [x11_1 x11_2 x11_3 x11_4 x11_5 x11_6];
syms x12_1 x12_2 x12_3 x12_4 x12_5 x12_6;
x12 = [x12_1 x12_2 x12_3 x12_4 x12_5 x12_6];
syms x13_1 x13_2 x13_3 x13_4 x13_5 x13_6;
x13 = [x13_1 x13_2 x13_3 x13_4 x13_5 x13_6];
syms x14_1 x14_2 x14_3 x14_4 x14_5 x14_6;
x14 = [x14_1 x14_2 x14_3 x14_4 x14_5 x14_6];
syms x15_1 x15_2 x15_3 x15_4 x15_5 x15_6;
x15 = [x15_1 x15_2 x15_3 x15_4 x15_5 x15_6];
syms x16_1 x16_2 x16_3 x16_4 x16_5 x16_6;
x16 = [x16_1 x16_2 x16_3 x16_4 x16_5 x16_6];
syms x17_1 x17_2 x17_3 x17_4 x17_5 x17_6;
x17 = [x17_1 x17_2 x17_3 x17_4 x17_5 x17_6];
syms x18_1 x18_2 x18_3 x18_4 x18_5 x18_6;
x18 = [x18_1 x18_2 x18_3 x18_4 x18_5 x18_6];
syms x19_1 x19_2 x19_3 x19_4 x19_5 x19_6;
x19 = [x19_1 x19_2 x19_3 x19_4 x19_5 x19_6];
syms x20_1 x20_2 x20_3 x20_4 x20_5 x20_6;
x20 = [x20_1 x20_2 x20_3 x20_4 x20_5 x20_6];
tsyms = [x1; x2; x3; x4; x5; x6; x7; x8; x9; x10; x11; x12; x13; x14; x15; x16; x17; x18; x19; x20];
syms c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20;
csyms = [c1; c2; c3; c4; c5; c6; c7; c8; c9; c10; c11; c12; c13; c14; c15; c16; c17; c18; c19; c20];
syms n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 n11 n12 n13 n14 n15 n16 n17 n18 n19 n20;
nsyms = [n1; n2; n3; n4; n5; n6; n7; n8; n9; n10; n11; n12; n13; n14; n15; n16; n17; n18; n19; n20];
ctl1 = CTimeleft(t_steps);
for t = 1:t_steps
    ctl1.timeleft();
    xp = tsyms(t,:);
    %TRANSITION PROBABILITIES
    sum_1 = exp( sum(b_12.*xp) ) + exp( sum(b_13.*xp) );
    sum_2 = exp( sum(b_21.*xp) ) + exp( sum(b_23.*xp) );
    sum_3 = exp( sum(b_31.*xp) ) + exp( sum(b_32.*xp) );
    q_it(1,1) = 1 / (1 + sum_1);
    q_it(1,2) = exp( sum(b_12.*xp) ) / (1 + sum_1);
    q_it(1,3) = exp( sum(b_13.*xp) ) / (1 + sum_1);
    q_it(2,1) = exp( sum(b_21.*xp) ) / (1 + sum_2);
    q_it(2,2) = 1 / (1 + sum_2);
    q_it(2,3) = exp( sum(b_23.*xp) ) / (1 + sum_2);
    q_it(3,1) = exp( sum(b_31.*xp) ) / (1 + sum_3);
    q_it(3,2) = exp( sum(b_32.*xp) ) / (1 + sum_3);
    q_it(3,3) = 1 / (1 + sum_3);
    %EMISSION PROBABILITIES
    c_it = csyms(t,:); n_it = nsyms(t,:);
    z_it = [xp,n_it];
    phi_it(2,2) = exp(c_it * sum(g_2.*z_it)) / (1 + exp(sum(g_2.*z_it))) * sum(t_2.*xp)^n_it * exp(-sum(t_2.*xp)) / factorial(n_it);
    phi_it(3,3) = exp(c_it * sum(g_3.*z_it)) / (1 + exp(sum(g_3.*z_it))) * sum(t_3.*xp)^n_it * exp(-sum(t_3.*xp)) / factorial(n_it);
    phi_it(1,1) = 0^c_it * 0^n_it;
    likelihood = likelihood * q_it * phi_it;
end

H = hessian(log(likelihood),all_syms);
disp('Finished Computing Hessians')
g = gradient(log(likelihood),all_syms);
disp('Finished Computing Gradient')


ctl2 = CTimeleft(n_iterations);
for i = 1:n_iterations
    ctl2.timeleft();
    g_i = zeros(size(all_syms));
    H_i = zeros(size(g,2));
    for j = 1:n_users
        g_j = g;
        H_j = H;
        g_j = subs(g_j,csyms,cit(i));
        H_j = subs(H_j,csyms,cit(i));
        g_j = subs(g_j,nsyms,nit(i));
        H_j = subs(H_j,nsyms,nit(i));
        for t = 1:t_steps
            g_j = subs(g_j,tsyms(t),[1,reshape(xprime(i,t,:),1,[])]);
            H_j = subs(H_j,tsyms(t),[1,reshape(xprime(i,t,:),1,[])]);
        end
        %Compute the gradient for current params, accumulate
        g_i = g_i + subs(g_j,all_syms,xn);
        %Compute the Hessian for current params, accumulate
        H_i = H_i + subs(H_j,all_syms,xn);
    end
    p = linsolve(H,g);
    xn_plus_one = xn - p .* xn;
    if norm(-p.*xn) < tolerance
        break;
    end
end