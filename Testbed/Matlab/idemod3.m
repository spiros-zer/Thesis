% A simple function to emulate Index Modulation (IM). Currently supporting
% IM for two timeslots only.

%%%%% INDEX DEMODULATION %%%%%
function [SYMBOLS, helper] = idemod3(y, M, SYMBOLS_IM)
% imod's counterpart. The logic is simpler, whenever a "0" mark is received
% no information is handled. On the other hand the identification of a "1"
% means the existence of an information symbol and it is saved.
i=1;
j=1;
helper = zeros(size(y));
SYMBOLS = zeros(length(y), 1); %we preallocate for speed
if M==2 %BPSK
    circle=0.5;
else %QPSK
    circle=0.3;
end
while true
    pos = norm(y(i)) - circle;
    if pos>0
        SYMBOLS(j) = y(i);
        j=j+1;
    end
    % A "helper" vector is now created to help with error calclations. This vector:
    % 1) has size equal to y (=the siganl after the channel)
    % 2) it has a 1-on-1 analogy with the symbols in y
    % 3) in it's slot a case is registered for error calculation
    % % 1st case: RX perceives a 0 timeslot when it should have been a 0 timeslot
    if pos<=0 && SYMBOLS_IM(i)==0
        helper(i,1)=00;
    % % 2nd case: RX perceives a 0 timeslot when it should have been a 1 timeslot
    elseif pos<=0 && SYMBOLS_IM(i)~=0
        helper(i,1)=01;
    % % 3rd case: RX perceives a 1 timeslot when it should have been a 0 timeslot
    elseif pos>0 && SYMBOLS_IM(i)==0
        helper(i,1)=10;
    % % 4th case: RX perceives a 1 timeslot when it should have been a 1 timeslot
    else
        helper(i,1)=11;
    end
    i=i+1;
    if i>length(y)
        break;
    end
end
% At this point the SYMBOLS stream should be the same size as the original
% symbol stream and in cases with no impulse resonance and/or noise the
% exact same content (use for validation).
SYMBOLS(j:end,:) = []; %we delete the null elements due to preallocation
end