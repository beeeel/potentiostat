function [FAout, fh] = plotAmperometryScaled(dirs, fnames, lC, lSt, nPerSty)

if ~exist('lSt','var')
    lSt = {'-','--',':','-.'};
end
if ~exist('nPerSty','var')
    nPerSty = 7;
end

fh = figure(3);
clf
clear h
FAout = cell(size(dirs));
count = 0;
for dIdx = 1:numel(dirs)
    FAout{dIdx} = cell(size(fnames{dIdx}));
    for fIdx = 1:numel(fnames{dIdx})
        count = count + 1;
        fname = [dirs{dIdx} fnames{dIdx}{fIdx}];
        [t, I, unit] = loadAmperometry(fname);
        
        str = strsplit(fname, {'_', '.'});
        ind = find(endsWith(str, 'V'));
        V = sscanf(str{ind}, '%f');
        if endsWith(str{ind}, 'mV'); V = 1e-3 * V; end
        % unit = sscanf(str{ind}, 
        FAout{dIdx}{fIdx} = [t; I];
        
        
        
%         yyaxis left
        h(count) = plot(t, 1e3*I./V,'LineWidth',2, 'LineStyle', lSt{ceil(count/nPerSty)});
        hold on
%         yyaxis right
%         semilogx(EIS(1,:), 360/2/pi*angle(EIS(2,:) + 1i * EIS(3,:)))
    end
end
% h(end+1) = plot([1e1 1e6], [1e9 1e4], 'k-');
% plot([1e-3 1e2], [1e8 1e3], 'k-');

legend(h, lC)
xlabel('Time (s)')
set(gca,'FontSize',16)
% ylabel('Phase angle (deg)')
% ylim([-90 90])
% yyaxis left
ylabel(sprintf('Current over Voltage (nA/V)', unit))