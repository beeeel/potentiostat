function [CVout, fh] = plotCyclicVoltammetry(dirs, fnames, lC, lSt, nPerSty)

if ~exist('lSt','var')
    lSt = {'-','--',':','-.'};
end
if ~exist('nPerSty','var')
    nPerSty = 7;
end

fh = figure();
clf
% fh.Position = [0 37 1890 960];

CVout = cell(size(dirs));
count = 0;
for dIdx = 1:numel(dirs)
    CVout{dIdx} = cell(size(fnames{dIdx}));
    for fIdx = 1:numel(fnames{dIdx})
        count = count + 1;
        fname = [dirs{dIdx} fnames{dIdx}{fIdx}];
        [V, I, units] = loadCyclicVoltametry(fname);
        CVout{dIdx}{fIdx} = [V I];
        h(count) = plot(V, I,'LineWidth',2, 'LineStyle', lSt{ceil(count/nPerSty)});
        hold on
    end
end
if exist('lC','var')
    legend(h, lC)
end
xlabel(sprintf('Voltage (%s)', units{1}))
ylabel(sprintf('Current (%s)', units{2}))
set(gca,'FontSize',16)

