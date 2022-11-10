function print_membership_functions_plot(var, range, count, type, plotname, filename, scale)
    if (nargin < 7)
        scale = 1.0;
    end

    tmin = min(min(range));
    tmax = max(max(range));

    n = 100;
    t = linspace(tmin, tmax, n * (count - 1) + 1);
    v = zeros(count, length(t));

    switch type
        case 'trimf'
            l = [zeros(1, round(n * (count - (1 + scale)))), linspace(0, 1, scale * n + 1)];
            r = [linspace(1, 0, scale * n + 1), zeros(1, round(n * (count - (1 + scale))))];
        case 'gaussmf'
            m = -(n * scale)^2 / log(0.5) / 4;
            l = exp(-(n * (count - 1) :-1 : 0).^2 / m);
            r = exp(-(0 : 1 : n * (count - 1)).^2 / m);
        otherwise
            return;
    end

    for k = 1 : count - 1
        last = k * n + 1;
        first = last - n;
        v(k, first : end)  = r(1 : end - first + 1);
        v(k + 1, 1 : last) = l(end - last + 1 : end);
    end

    figure('Name', plotname);
    for k = 1 : count
        plot(t, v(k, :), '-');
        hold on;
    end

    axis([tmin, tmax, 0, 1.2])
    xticks(linspace(tmin, tmax, max(count, 5)));
    xticklabels({'-1', '-2/3', '-1/3', '0', '1/3', '2/3', '1'});
    grid on;

    set(gca, 'FontName', 'Euclid', 'FontSize', 12);
    title(plotname, 'Interpreter', 'latex', 'FontSize', 12);
    xlabel(['$', var, '$'], 'Interpreter', 'latex', 'FontSize', 12);
    ylabel(['$\mu(', var, ')$'], 'Interpreter', 'latex', 'FontSize', 12);

    switch var
        case 'error'
            xlabel('$e_x, \rm m$', 'Interpreter', 'latex', 'FontSize', 12);
            ylabel('$\mu(e_x)$', 'Interpreter', 'latex', 'FontSize', 12);
            legend('negative-big', 'negative-middle', 'negative-small', 'zero', 'positive-middle', ...
                   'positive-small', 'positive-big', 'Interpreter', 'latex', 'FontSize', 10, 'Location', 'southeast')
        case 'rate'
            xlabel('$\dot{e}_x, \rm m/s$', 'Interpreter', 'latex', 'FontSize', 12);
            ylabel('$\mu(\dot{e}_x)$', 'Interpreter', 'latex', 'FontSize', 12);
            legend('negative-big', 'negative-middle', 'negative-small', 'zero', 'positive-middle', ...
                   'positive-small', 'positive-big', 'Interpreter', 'latex', 'FontSize', 10, 'Location', 'southeast')
        case 'voltage'
            xlabel('$u$, \rm V', 'Interpreter', 'latex', 'FontSize', 12);
            ylabel('$\mu(u)$', 'Interpreter', 'latex', 'FontSize', 12);
            legend('negative-big', 'negative-middle', 'negative-small', 'zero', 'positive-middle', ...
                   'positive-small', 'positive-big', 'Interpreter', 'latex', 'FontSize', 10, 'Location', 'southeast')
    end

    if (~exist('../../graphs', 'dir'))
        mkdir('../../graphs');
    end

    print(['../../graphs/', filename], '-dmeta', '-r0');
end