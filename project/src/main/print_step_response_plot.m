function print_step_response_plot(var, t, xd, x, plotname, filename)
    figure('Name', plotname);
    if (isempty(xd) ~= true)
        plot(t, xd); hold on;
    end
    plot(t, x);
    xticks(linspace(t(1), t(end), 11));

    grid on;
    set(gca, 'FontName', 'Euclid', 'FontSize', 12);
    title(plotname, 'FontWeight', 'normal', 'FontSize', 12);

    xname = 'x';
    xunit = 'm';
    switch var
        case 'voltage'
            xname = 'u';
            xunit = 'V';
        case 'voltaged'
            xname = 'u_d';
            xunit = 'V';
        case 'speed'
            xname = 'v';
            xunit = 'm/s';
        case 'angle'
            xname = '\varphi';
            xunit = 'rad';
        case 'angspeed'
            xname = '\omega';
            xunit = 'rad/s';
        case 'error'
            xname = 'e_x';
            xunit = 'm';
        case 'rate'
            xname = '\dot{e_x}';
            xunit = 'm/s';
    end

    xlabel('$t, \rm s$',    'Interpreter', 'latex', 'FontSize', 12);
    ylabel(['$', xname, '(t), \rm ', xunit, '$'], 'Interpreter', 'latex', 'FontSize', 12);
    if (isempty(xd) ~= true)
        legend(['$', xname,'_d(t)$'], ['$', xname,'(t)$'], 'Interpreter', 'latex', 'FontSize', 10);
    end
    
    if (~exist('../../graphs', 'dir'))
        mkdir('../../graphs');
    end

    print(['../../graphs/', filename], '-dmeta', '-r0');
end