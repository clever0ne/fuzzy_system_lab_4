clc; clear; close all;

g = 9.81;
time = 50;

mt = 300;
ml = 400;
l  = 30;
k  = 10;

k_error   = 0.025;
k_rate    = 0.3;
k_voltage = 60;

n = 21;
xmin = -1;
xmax =  1;
ymin = -1;
ymax =  1;

k1 = 0.85;
k2 = 1.15;
k3 = 0.50;
k4 = 1.50;

x1 = linspace(xmin, xmax, n);
x2 = linspace(xmin, xmax, n);
y = linspace(ymin, ymax, n);
x = reshape(cat(3, repmat(x1, length(x2), 1)', ...
                   repmat(x2, length(x1), 1)), [], 2, 1);

fis1 = readfis('../model/mamdani_trimf_7in_trimf_7out.fis'    );
fis2 = readfis('../model/mamdani_trimf_7in_gaussmf_7out.fis'  );
fis3 = readfis('../model/mamdani_gaussmf_7in_trimf_7out.fis'  );
fis4 = readfis('../model/mamdani_gaussmf_7in_gaussmf_7out.fis');

print_membership_functions_plot('error',   x1, 7, 'trimf', 'Triangle MF', 'error_trimf_7in.emf'  );
print_membership_functions_plot('rate',    x2, 7, 'trimf', 'Triangle MF', 'rate_trimf_7in.emf'   );
print_membership_functions_plot('voltage', y,  7, 'trimf', 'Triangle MF', 'voltage_trimf_7in.emf');

print_membership_functions_plot('error',   x1, 7, 'gaussmf', 'Gauss MF', 'error_gaussmf_7in.emf'  );
print_membership_functions_plot('rate',    x2, 7, 'gaussmf', 'Gauss MF', 'rate_gaussmf_7in.emf'   );
print_membership_functions_plot('voltage', y,  7, 'gaussmf', 'Gauss MF', 'voltage_gaussmf_7in.emf');

y1 = reshape(evalfis(fis1, x), length(x1), length(x2))';
print_surface_plot(x1, x2, y1, 'Mamdani Triangle MF System', ...
                   'mamdani_trimf_7in_trimf_7out_surface');

y2 = reshape(evalfis(fis2, x), length(x1), length(x2))';
print_surface_plot(x1, x2, y2, 'Mamdani Triangle-Gauss MF System', ...
                   'mamdani_trimf_7in_gaussmf_7out_surface');

y3 = reshape(evalfis(fis3, x), length(x1), length(x2))';
print_surface_plot(x1, x2, y3, 'Mamdani Gauss-Triangle MF System', ...
                   'mamdani_gaussmf_7in_trimf_7out_surface');

y4 = reshape(evalfis(fis4, x), length(x1), length(x2))';
print_surface_plot(x1, x2, y4, 'Mamdani Gauss MF System', ...
                   'mamdani_gaussmf_7in_gaussmf_7out_surface');

print_surface_plot(x1, x2, y1, '', 'mamdani_7in_7out_surface');
print_membership_functions_plot('error',   x1, 7, 'trimf', '', 'error_7in.emf'  );
print_membership_functions_plot('rate',    x2, 7, 'trimf', '', 'rate_7in.emf'   );
print_membership_functions_plot('voltage', y,  7, 'trimf', '', 'voltage_7in.emf');

system = '../system/overhead_crane.slx';
sim(system, time);

system = '../system/overhead_crane_control.slx';
time = 300;

t     = data1(:, 1);
u     = data1(:, 2);
x     = data2(:, 2);
v     = data2(:, 3);
phi   = data3(:, 2);
omega = data3(:, 3);

print_step_response_plot('voltage',  t, [], u,     '', 'voltage_step_response.emf' );
print_step_response_plot('position', t, [], x,     '', 'position_step_response.emf');
print_step_response_plot('speed',    t, [], v,     '', 'speed_step_response.emf'   );
print_step_response_plot('angle',    t, [], phi,   '', 'velocity_step_response.emf');
print_step_response_plot('angspeed', t, [], omega, '', 'angspeed_step_response.emf');

Ke = k_error; Kde = k_rate; Ku = k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Mamdani Triangle MF System Step Response', ...
                         'mamdani_trimf_7in_trimf_7out_step_response');

Ke = k_error; Kde = k_rate; Ku = k_voltage; fis = fis2;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Mamdani Triangle-Gauss MF System Step Response', ...
                         'mamdani_trimf_7in_gaussmf_7out_step_response');

Ke = k_error; Kde = k_rate; Ku = k_voltage; fis = fis3;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Mamdani Gauss-Triangle MF System Step Response', ...
                         'mamdani_gaussmf_7in_trimf_7out_step_response');

Ke = k_error; Kde = k_rate; Ku = k_voltage; fis = fis4;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Mamdani Gauss MF System Step Response', ...
                         'mamdani_gaussmf_7in_gaussmf_7out_step_response');

Ke = k1 * k_error; Kde = k_rate; Ku = k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 1st Parameter –15 %', ...
                         'mamdani_7in_7out_ke_k1_step_response');

Ke = k2 * k_error; Kde = k_rate; Ku = k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 1st Parameter +15 %', ... 
                         'mamdani_7in_7out_ke_k2_step_response');

Ke = k3 * k_error; Kde = k_rate; Ku = k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 1st Parameter –50 %', ...
                         'mamdani_7in_7out_ke_k3_step_response');

Ke = k4 * k_error; Kde = k_rate; Ku = k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 1st Parameter +50 %', ...
                         'mamdani_7in_7out_ke_k4_step_response');

Ke = k_error; Kde = k1 * k_rate; Ku = k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 2nd Parameter –15 %', ...
                         'mamdani_7in_7out_kde_k1_step_response');

Ke = k_error; Kde = k2 * k_rate; Ku = k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 2nd Parameter +15 %', ... 
                         'mamdani_7in_7out_kde_k2_step_response');

Ke = k_error; Kde = k3 * k_rate; Ku = k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 2nd Parameter –50 %', ...
                         'mamdani_7in_7out_kde_k3_step_response');

Ke = k_error; Kde = k4 * k_rate; Ku = k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 2nd Parameter +50 %', ...
                         'mamdani_7in_7out_kde_k4_step_response');

Ke = k_error; Kde = k_rate; Ku = k1 * k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 3rd Parameter –15 %', ...
                         'mamdani_7in_7out_ku_k1_step_response');

Ke = k_error; Kde = k_rate; Ku = k2 * k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 3rd Parameter +15 %', ... 
                         'mamdani_7in_7out_ku_k2_step_response');

Ke = k_error; Kde = k_rate; Ku = k3 * k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 3rd Parameter –50 %', ...
                         'mamdani_7in_7out_ku_k3_step_response');

Ke = k_error; Kde = k_rate; Ku = k4 * k_voltage; fis = fis1;
sim(system, time);
t = data1(:, 1); xd = data1(:, 2); x = data1(:, 3);
print_step_response_plot('position', t, xd, x, 'Step Response 3rd Parameter +50 %', ...
                         'mamdani_7in_7out_ku_k4_step_response');

Ke = k_error; Kde = k_rate; Ku = k_voltage; fis = fis1;
sim(system, time);

t     = data1(:, 1);
xd    = data1(:, 2);
x     = data1(:, 3);
u     = data1(:, 4);
v     = data2(:, 3);
phi   = data3(:, 2);
omega = data3(:, 3);
e     = data4(:, 2);
de    = data4(:, 3);
ud    = data4(:, 4);

print_step_response_plot('position', t, xd, x,     '', 'mamdani_7in_7out_position_step_response.emf');
print_step_response_plot('speed',    t, [], v,     '', 'mamdani_7in_7out_speed_step_response.emf'   );
print_step_response_plot('angle',    t, [], phi,   '', 'mamdani_7in_7out_angle_step_response.emf'   );
print_step_response_plot('angspeed', t, [], omega, '', 'mamdani_7in_7out_angspeed_step_response.emf');
print_step_response_plot('voltage',  t, [], u,     '', 'mamdani_7in_7out_voltage_step_response.emf' );
print_step_response_plot('voltaged', t, [], ud,    '', 'mamdani_7in_7out_voltaged_step_response.emf');
print_step_response_plot('error',    t, [], e,     '', 'mamdani_7in_7out_error_step_response.emf'   );
print_step_response_plot('rate',     t, [], de,    '', 'mamdani_7in_7out_rate_step_response.emf'    );
