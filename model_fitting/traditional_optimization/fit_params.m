clear;
load attribution;
lowerbnd = [-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6];
upperbnd = [6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6];
x0 = [-5,0,0,0,0,0,-5,0,0,0,0,0,-5,0,0,0,0,0,-5,0,0,0,0,0,-5,0,0,0,0,0,-5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

n_iterations = 10;
t = CTimeleft(n_iterations);
overall_minx = x0;
overall_minfx = Inf;
for i = 1:n_iterations
    t.timeleft();
    % add some random noise to the initial guess, note the initial guess
    % places the beta-intercepts at -5, since the states are presumably
    % sticky
    noise = 0.25 * randn(size(x0));
    lbndnoise = lowerbnd + noise;
    ubndnoise = upperbnd + noise;
    xnoise = x0 + noise;
    wrapper_handle = @(s) ll(s(1),s(2),s(3),s(4),s(5),s(6),s(7),s(8),s(9),s(10),s(11),s(12),s(13),s(14),s(15),s(16),s(17),s(18),s(19),s(20),s(21),s(22),s(23),s(24),s(25),s(26),s(27),s(28),s(29),s(30),s(31),s(32),s(33),s(34),s(35),s(36),s(37),s(38),s(39),s(40),s(41),s(42),s(43),s(44),s(45),s(46),s(47),s(48),s(49),s(50),s(51),s(52),s(53),s(54),s(55),s(56),s(57),s(58),s(59),s(60),s(61),s(62),cit,nit,xprime);
    xmin =  fminsearchbnd(wrapper_handle,xnoise,lbndnoise,ubndnoise);
    % find the objective function value of the minimum
    xmin_fval = wrapper_handle(xmin);
    if xmin_fval < overall_minfx
        overall_minfx = xmin_fval;
        overall_minx = xmin;
    end
end
overall_minfx
overall_minx