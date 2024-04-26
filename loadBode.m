function [f, Zstar] = loadBode(filename)
% out = loadBode(filename)
%% Read csv from dropView and return nyquist data ([f; Z'; Z''])
fid = fopen(filename);

str = '';

% Skip to the nyquist data
while ~contains(str, 'bodePhase')
    str = fgetl(fid);
end
% Skip two more lines (blank line and table header)
[~] = fgetl(fid);
[~] = fgetl(fid);

phi = NaN(2,1e3);
count = 1;
while ~feof(fid)
    str = fgetl(fid);
    try
        phi(:,count) = sscanf(str, '"%g";"%g"');
        count = count + 1;
    catch
        break
    end
end
f = phi(1,1:count-1);
phi = phi(2, 1:count-1);

% Skip to the nyquist data
while ~contains(str, 'bodeZmod')
    str = fgetl(fid);
end
% Skip two more lines (blank line and table header)
[~] = fgetl(fid);
[~] = fgetl(fid);

Zmod = NaN(2,1e3);
count = 1;
while ~feof(fid)
    str = fgetl(fid);
    try
        Zmod(:,count) = sscanf(str, '"%g";"%g"');
        count = count + 1;
    catch
        break
    end
end
Zmod = Zmod(2, 1:count-1);

Zstar = Zmod .* exp(-1i.*phi*2*pi/360);