% PURPOSE:
%   This function plots the evolution of generalized coordinates (and optionally other signals) 
%   over time using subplots. It can display one or two datasets, customize colors, labels, 
%   legends, and optionally save the figure to a file.
%
% SYNTAX:
%   PlotEq(x1, t, ftitle, ylabels, legends)
%   PlotEq(x1, t, ftitle, ylabels, legends, 'Other', x2)
%   PlotEq(x1, t, ftitle, ylabels, legends, 'Span', span)
%   PlotEq(x1, t, ftitle, ylabels, legends, 'Colors', colors)
%   PlotEq(x1, t, ftitle, ylabels, legends, 'Save', filename)
%   PlotEq(..., 'Other', x2, 'Span', span, 'Colors', colors, 'Save', filename)
%
% INPUTS:
%   x1       - (Matrix)    It contains the generalized coordinates and its derivatives.
%   t        - (Array)     Time range for simulation.
%   ftitle   - (String)    Title for the figure.
%   ylabels  - (Array)     Contains a list of strings with the y-axis labels of each subplot.
%   legends  - (Array)     Contains a list of strings with the names of each curve.
%   varargin - Optional arguments:
%              'Save'   - (String)    Name of the file to save the figure (include the extension).
%              'Other'  - (Matrix)    Second input signal (x2). It should have the same size as x1.
%              'Span'   - (Array)     Columns to be selected from matrices x1 and/or x2.
%              'Colors' - (Matrix)    Each row contains the triplet of values to define the color of each curve.
%
% OUTPUTS:
%   A figure with N subplots, each corresponding to a selected variable in x1 (and optionally x2).
%   The figure is saved to the "Pictures" directory if the 'Save' option is provided.
% 
% Note: If you use a second input signal ('Other'), the second half of the arrays "legends" and "colors" 
%       should contain the names and colors of the new curves
%
% AUTHOR:
%   William Cancino, 2023


function PlotEq(x1, t, ftitle, ylabels, legends, varargin)   
    % Default values
    flg_x2 = false;
    flg_save = false;
    flg_colors = false;

    N = (size(x1,2)/2);
    span = 1:N;
    
    c1 = [0 120 255]/255;
    c2 = [255 102 0]/255;

    % If varargin contains all values in a single cell, they are extracted to separate cells
    if numel(varargin) == 1, varargin = varargin{:}; end

    % Search the values for optional arguments
    for i = 1:2:length(varargin)
        switch varargin{i}
            case 'Save'                     % Save the figure
                flg_save = true;
                name_file = varargin{i+1};
            case 'Other'                    % Plot other input signal
                flg_x2 = true;
                x2 = varargin{i+1};
                x2 = x2(:, span);
            case 'Span'                     % Select columns from input signal
                span = varargin{i+1};
                N = length(span);
            case 'Colors'                   % Colors for the curves
                flg_colors = true;
                colors = varargin{i+1};
            otherwise
                error('Invalid argument');
        end
    end

    % Default colors in the plot
    if ~flg_colors
        colors = [repmat(c1, N, 1); repmat(c2, N, 1)];
    end

    % Create folder for saving pictures
    if (exist('Pictures', 'dir')~=7) && flg_save, mkdir('Pictures'); end

    % Extract important columns of x1
    x1 = x1(:, span);

    % Plot
    for i = 1:N
        subplot(N, 1, i);
        flgd = [];
        if flg_x2
            plot(t, x2(:, i), 'Color', colors(i+N, :), 'LineWidth', 2)
            hold on
            flgd = [legends(i+N)];
        end        
        plot(t, x1(:, i), 'Color', colors(i, :), 'LineWidth', 1.5)
        hold off
        flgd = [flgd legends(i)];
        legend(flgd, 'Location', 'NorthEast', 'Interpreter', 'Latex', 'FontSize', 12)
        xlabel("Time [s]", 'fontweight','bold')
        ylabel(ylabels(i), 'fontweight','bold')
    end
    sgtitle(ftitle)

    % Save figure
    if flg_save, saveas(gcf, "Pictures/"+name_file); end
end