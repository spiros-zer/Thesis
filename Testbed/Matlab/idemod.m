% A simple function to emulate Index Modulation (IM). Currently supporting
% IM for two timeslots only.

%%%%% INDEX DEMODULATION %%%%%
function SYMBOLS = idemod(y)
% imod's counterpart. The logic is simpler, whenever a "0" mark is received
% no information is handled. On the other hand the identification of a "1"
% means the existence of an information symbol and it is saved.
% disp('new iter')
i = 1;
k = 1;
SYMBOLS = zeros(length(y), 1); %we preallocate for speed
if isreal(y)
    map = [0 -1 1];
else
    map = [0 1+1i 1-1i -1-1i -1+1i];
end
while true
    [~, pos] = min(abs(y(i)-map));
    if pos ~= 1
%     if abs(y(i)) > 0.5589 % Gia SNRdB > 15 (me hands-on approach)
        SYMBOLS(k) = y(i);
        k = k+1;
    end
    i = i+1;
    if i > length(y)
        break;
    end
end
% At this point the SYMBOLS stream should be the same size as the original
% symbol stream and in cases with no impulse resonance and/or noise the
% exact same content (use for validation).
SYMBOLS(k:end,:) = []; %we delete the null elements due to preallocation
end