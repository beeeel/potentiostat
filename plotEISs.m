function [EISout, fh] = plotEISs(dirs, fnames, lC, lSt, nPerSty)

if ~exist('lSt','var')
    lSt = {'-','--',':','-.'};
end
if ~exist('nPerSty','var')
    nPerSty = 7;
end

fh = figure();
clf
% fh.Position = [0 37 1890 960];

EISout = cell(size(dirs));
count = 0;
for dIdx = 1:numel(dirs)
    EISout{dIdx} = cell(size(fnames{dIdx}));
    for fIdx = 1:numel(fnames{dIdx})
        count = count + 1;
        fname = [dirs{dIdx} fnames{dIdx}{fIdx}];
        if ~exist(fname, 'file') && exist([fname '.csv'], 'file')
            fname = [fname '.csv'];
        end
        EIS = loadNyquist(fname);
        EISout{dIdx}{fIdx} = EIS;
        
%         yyaxis left
        h(count) = loglog(EIS(1,:), abs(EIS(2,:) + 1i * EIS(3,:)),'LineWidth',2, 'LineStyle', lSt{ceil(count/nPerSty)});
        hold on
%         yyaxis right
%         semilogx(EIS(1,:), 360/2/pi*angle(EIS(2,:) + 1i * EIS(3,:)))
    end
end
h(end+1) = plot([1e1 1e6], [1e9 1e4], 'k-');
plot([1e-3 1e2], [1e8 1e3], 'k-');

legend(h, [lC 'f^{-1}'])
xlabel('Frequency (Hz)')
set(gca,'FontSize',16)
% ylabel('Phase angle (deg)')
% ylim([-90 90])
% yyaxis left
ylabel('|Z| (Ω)')
