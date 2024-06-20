function Zstar = analyseImpedanceSpectrum(time, voltage, current, Vfs, zp)
%% Zstar = analyseImpedanceSpectrum(time, voltage, current, Vfs, [zp])
%% Calculate complex impedance spectrum (Zstar) using time domain sine wave voltammetry
% Well, actually, in theory, you could use any voltammetry but I don't
% really know how well it performs when it's not sine wave, plus there's
% definitely a better fourier transform you can use for step relaxation.
% Maybe I'll make that a MATLAB function soon.

nP = size(time,1);
nF = size(time,2);

if any(size(voltage) ~= [nP, nF]) || any(size(current) ~= [nP, nF]) || numel(Vfs) ~= nF
    nums = [nP, nF, size(voltage), size(current), numel(Vfs)];
    str = sprintf('Incorrect size inputs: time: %iz%i, current: %ix%i, voltage: %ix%i, Vfs: %i', nums);
    error(str  ) %#ok<SPERR> % stupid code analyser.
end

if ~exist('zp','var')
    zp = max(2^16, 2^nextpow2(nP));
end

Zstar = zeros(1,nF);
for fidx = 1:nF
    t  = time(:, fidx);
    V  = voltage(:, fidx);
    I = current(:, fidx);

    delta_t = t(2) - t(1);
    t2      = delta_t * (1:zp);
    T       = t2(end)-t2(1);
    freq    = ((1 : length(t2)) / T)';

    Vfreq   = delta_t * fft(V,zp);
    Ifreq   = delta_t * fft(I,zp);

    ind     =   find(freq <= (0.5/delta_t)); % only to the Nyquist f
    ind     =   ind(2:end);
    freq    =   freq(ind);
    Vfreq   =   Vfreq(ind,:);
    Ifreq   =   Ifreq(ind,:);

    [er, fi] = min(abs(freq - Vfs(fidx)));

    Zstar(fidx) = Vfreq(fi) ./ Ifreq(fi);
end
figure()
clf
yyaxis left
loglog(Vfs, abs(Zstar),'k-')
ylabel('|Z| (\Omega)')
yyaxis right
semilogx(Vfs, -angle(Zstar)*360/2/pi,'r--')
ylabel('Phase angle (°)')
xlabel('Frequency (Hz)')


% save(sprintf('impedance_100mV_%s.mat', curr{idx}), 'Zstar','Vfs');
end